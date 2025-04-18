// Core imports

use core::debug::PrintTrait;

// Starknet imports

use starknet::testing::{
    set_contract_address, set_account_contract_address, set_transaction_hash, set_block_timestamp
};

// Dojo imports

use dojo::world::{WorldStorage, IWorldDispatcherTrait, WorldStorageTrait};
use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
use dojo::model::Model;

// Internal imports

use zkube::constants;
use zkube::store::{Store, StoreTrait};
use zkube::models::game::{Game, GameTrait};
use zkube::models::player::{Player, PlayerTrait};
use zkube::systems::play::IPlayDispatcherTrait;
use zkube::types::mode::Mode;

// Test imports

use zkube::tests::setup::{
    setup,
    setup::{
        Systems, PLAYER1, PLAYER2, PLAYER3, PLAYER4, IERC20DispatcherTrait, verify_system_allowance,
        user_mint_token, admin_mint_token, impersonate
    }
};

#[test]
fn test_patch_u16_game_started_before_update() {
    // [Setup]
    let (mut world, systems, context) = setup::create_accounts();
    let erc721_addr = context.erc721.contract_address;
    let erc20_addr = context.erc20.contract_address;
    let store = StoreTrait::new(world);

    // [Set] Game
    impersonate(PLAYER1());
    let token_id = user_mint_token(context.play_address, erc721_addr, erc20_addr, PLAYER1().into());
    let game_id = systems
        .play
        .create(token_id, Mode::Daily, context.proof.clone(), context.seed, context.beta);

    let mut game = store.game(game_id);
    game.blocks = 0b010010000000000000000000000001001001001001001001000001001001001001001001;
    game.combo_counter = 15;
    game.combo_counter_2 = 0;
    game.combo_counter_in_tournament = 15;
    game.combo_counter_in_tournament_2 = 0;
    world.write_model_test(@game);

    // UPDATE

    // [Move]
    systems.play.move(1, 6, 7);

    let mut game = store.game(game_id);

    // [Check] Game
    assert_eq!(game.combo_counter_2, 17);
    assert_eq!(game.combo_counter_in_tournament_2, 17);

    game.blocks = 0b010010000000000000000000000001001001001001001001000001001001001001001001;
    world.write_model_test(@game);

    systems.play.move(1, 6, 7);

    // [Check] Game
    let mut game = store.game(game_id);
    assert_eq!(game.combo_counter_2, 19);
    assert_eq!(game.combo_counter_in_tournament_2, 19);
}

#[test]
fn test_patch_u16_game_started_after_update() {
    // [Setup]
    let (mut world, systems, context) = setup::create_accounts();
    let erc721_addr = context.erc721.contract_address;
    let erc20_addr = context.erc20.contract_address;
    let store = StoreTrait::new(world);

    // UPDATE

    // [Set] Game
    impersonate(PLAYER1());
    let token_id = user_mint_token(context.play_address, erc721_addr, erc20_addr, PLAYER1().into());
    let game_id = systems
        .play
        .create(token_id, Mode::Daily, context.proof.clone(), context.seed, context.beta);

    let mut game = store.game(game_id);
    game.blocks = 0b010010000000000000000000000001001001001001001001000001001001001001001001;
    world.write_model_test(@game);

    // [Move]
    systems.play.move(1, 6, 7);

    let mut game = store.game(game_id);

    // [Check] Game
    assert_eq!(game.combo_counter_2, 2);
    assert_eq!(game.combo_counter_in_tournament_2, 2);
    assert_eq!(game.combo_counter, 0);
    assert_eq!(game.combo_counter_in_tournament, 0);
}

#[test]
fn test_patch_u16_bigger_than_255() {
    // [Setup]
    let (mut world, systems, context) = setup::create_accounts();
    let erc721_addr = context.erc721.contract_address;
    let erc20_addr = context.erc20.contract_address;
    let store = StoreTrait::new(world);

    // UPDATE

    // [Set] Game
    impersonate(PLAYER1());
    let token_id = user_mint_token(context.play_address, erc721_addr, erc20_addr, PLAYER1().into());
    let game_id = systems
        .play
        .create(token_id, Mode::Daily, context.proof.clone(), context.seed, context.beta);

    let mut game = store.game(game_id);
    game.blocks = 0b010010000000000000000000000001001001001001001001000001001001001001001001;
    game.combo_counter = 255;
    game.combo_counter_2 = 0;
    game.combo_counter_in_tournament = 255;
    game.combo_counter_in_tournament_2 = 0;
    world.write_model_test(@game);

    // [Move]
    systems.play.move(1, 6, 7);

    let mut game = store.game(game_id);

    // [Check] Game
    assert_eq!(game.combo_counter_2, 257);
    assert_eq!(game.combo_counter_in_tournament_2, 257);
    assert_eq!(game.combo_counter, 255);
    assert_eq!(game.combo_counter_in_tournament, 255);
}

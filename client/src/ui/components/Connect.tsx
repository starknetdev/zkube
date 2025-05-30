import { useConnect, useAccount } from "@starknet-react/core";
import { motion } from "framer-motion";
import { useMediaQuery } from "react-responsive";
import { trackEvent } from "@/services/analytics";
import { useCallback } from "react";

interface connectProps {
  inMenu?: boolean;
}

const Connect: React.FC<connectProps> = ({ inMenu = false }) => {
  const { connect, connectors } = useConnect();
  const { address, status } = useAccount();
  const isMediumOrLarger = useMediaQuery({ query: "(min-width: 768px)" });

  const handleConnect = useCallback(() => {
    trackEvent("Connect Wallet Clicked", {
      interface: isMediumOrLarger ? "desktop" : "mobile",
    });
    connect({ connector: connectors[0] });
  }, [isMediumOrLarger, connect]);

  if (status === "connected" && address) {
    return null;
  }

  return (
    <div className="flex items-center gap-3">
      {connectors.map((connector) => (
        <span key={connector.id}>
          <motion.div
            animate={
              !inMenu && {
                translateY: [0, -8, 0, -8, 2, 2, -8, 0, -8, 0],
                backgroundColor: [
                  "#FFFFFF",
                  "#47D1D9",
                  "#8BA3BC",
                  "#1974D1",
                  "#44A4D9",
                  "#FFFFFF",
                ],
              }
            }
            transition={{
              duration: 2,
              ease: "easeInOut",
              repeat: Infinity,
              repeatDelay: 1,
            }}
            onClick={handleConnect}
            className={`${!inMenu ? `cursor-pointer p-2 text-black bg-blue-500 font-bold ${!isMediumOrLarger ? "rounded-none border-4 border-black" : "rounded-lg"}` : "cursor-pointer p-2 border-2 rounded-lg font-bold"}`}
          >
            Connect
          </motion.div>
        </span>
      ))}
    </div>
  );
};

export default Connect;

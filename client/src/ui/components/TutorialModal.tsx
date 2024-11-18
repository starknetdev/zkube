import React from "react";
import { Dialog, DialogContent, DialogTitle } from "../elements/dialog";
import { Button } from "../elements/button";
import ImageAssets from "@/ui/theme/ImageAssets";
import { useTheme } from "../elements/theme-provider/hooks";
import { X } from "lucide-react";
interface TutorialModalProps {
  isOpen: boolean;
  onClose: () => void;
  onStartTutorial: () => void;
}
const TutorialModal = ({
  isOpen,
  onClose,
  onStartTutorial,
}: TutorialModalProps) => {
  const { themeTemplate } = useTheme();
  const imgAssets = ImageAssets(themeTemplate);
  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent
        className="sm:max-w-[700px] w-[95%] flex flex-col mx-auto justify-start"
        aria-describedby="tutorial-description"
      >
        <DialogTitle className="text-center">Tutorial</DialogTitle>
        <button
          onClick={onClose}
          className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground"
          aria-label="Close tutorial"
        >
          <X className="h-4 w-4" />
        </button>
        <div className="flex justify-center items-center w-full h-10">
          <img src={imgAssets.logo} alt="logo" className={`h-28 md:h-32 `} />
        </div>
        <div
          id="tutorial-description"
          className="flex-1 flex flex-col items-center justify-center min-h-[300px] text-center p-6"
        >
          <h2 className="text-2xl font-semibold mb-6">
            Welcome to ZKube Tutorial
          </h2>
          <p className="mb-8 text-lg text-white">
            Get started with our interactive tutorial to learn all the features.
          </p>
          <Button onClick={onStartTutorial} className="px-6 py-2 text-lg">
            Click Here to Start
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default TutorialModal;

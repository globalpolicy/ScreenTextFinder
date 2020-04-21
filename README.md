# ScreenTextFinder
A program to find texts on your screen using Tesseract OCR
<p>
The project needs all the tesseract units (.pas files in the TesseractUnits folder). These are the wrappers for the tesseract OCR engine. Ref: https://github.com/r1me/TTesseractOCR4

The the program needs all the tesseract .dll files. The .dll files are not created by the project, but downloaded externally.<br>
It also needs a training data file such as "eng.traineddata" for functioning. This is also not created by the project, but downloaded externally.<br>
Both these external dependencies are in the TesseractDllAndTraining folder. Copy the contents to the Debug or Release folder while using the IDE to write code in the Debug or Release modes. The program needs these dependencies.

The program expects the tesseract .dlls and the training data files to be in the same directory it runs from.
</p>

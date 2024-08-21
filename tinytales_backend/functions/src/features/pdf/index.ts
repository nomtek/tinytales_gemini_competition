import { PDFDocument, PDFPage, rgb } from "pdf-lib";
import fs, { unlinkSync } from "fs";
import fetch from "node-fetch";
import os = require("os");
import path = require("path");
import { Storage } from "@google-cloud/storage";
import { getStorage } from "firebase-admin/storage";
import fontkit from "@pdf-lib/fontkit";
import { FONTS } from "../../assets/fonts/index.js";

const storage = new Storage();

async function createPdf(
  title: string,
  photoPath: string | null,
  text: string,
  uid: string
) {
  const pdfDoc = await PDFDocument.create();
  const pageWidth = 595; // A4 width in points
  const pageHeight = 842; // A4 height in points
  const borderWidth = 20;
  const margin = 50;
  const textFontSize = 13;
  const lineHeight = textFontSize * 1.4;
  const textWidth = pageWidth - 2 * margin;

  //decode from fontBase64
  const fontBytes = Buffer.from(FONTS.OpenSans, "base64");
  //convert font bytes to base64

  pdfDoc.registerFontkit(fontkit);
  const customFont = await pdfDoc.embedFont(fontBytes);

  const titleFont = customFont; // await pdfDoc.embedFont(StandardFonts.HelveticaBold);
  const textFont = customFont; //= await pdfDoc.embedFont(StandardFonts.Helvetica);

  let currentPage = pdfDoc.addPage([pageWidth, pageHeight]);
  let currentHeight = pageHeight - margin;

  // Function to add a new page
  const addNewPage = () => {
    currentPage = pdfDoc.addPage([pageWidth, pageHeight]);
    currentHeight = pageHeight - margin;
    drawBorder(currentPage);
  };

  // Function to draw border
  const drawBorder = (page: PDFPage) => {
    page.drawRectangle({
      x: borderWidth / 2,
      y: borderWidth / 2,
      width: pageWidth - borderWidth,
      height: pageHeight - borderWidth,
      borderColor: rgb(87 / 255, 89 / 255, 146 / 255),
      borderWidth,
    });
  };

  // Draw the initial border
  drawBorder(currentPage);

  // Add title
  // const titleTextWidth = titleFont.widthOfTextAtSize(text, 30);
  // Add title
  const titleLines = title.split(" ").reduce(
    (acc, word) => {
      const lastLine = acc[acc.length - 1];
      const testLine = lastLine ? `${lastLine} ${word}` : word;
      const width = titleFont.widthOfTextAtSize(testLine, 30);
      if (width < textWidth) {
        acc[acc.length - 1] = testLine;
      } else {
        acc.push(word);
      }
      return acc;
    },
    [""]
  );

  for (const line of titleLines) {
    const titleTextWidth = titleFont.widthOfTextAtSize(line, 30);
    const x = (pageWidth - titleTextWidth) / 2;
    currentPage.drawText(line, {
      x,
      y: currentHeight - 30,
      size: 30,
      font: titleFont,
      color: rgb(0, 0, 0),
    });
    currentHeight -= 40;
  }
  currentHeight -= 30;

  // Add photo if available
  if (photoPath) {
    const response = await fetch(photoPath);
    const imageBytes = await response.arrayBuffer();
    const image = await pdfDoc.embedPng(imageBytes);

    const imageDims = image.scale(0.5);
    const imageWidth = Math.min(imageDims.width, pageWidth * 0.5);
    const imageHeight = (imageWidth / imageDims.width) * imageDims.height;
    const imageX = (pageWidth - imageWidth) / 2;
    currentPage.drawImage(image, {
      x: imageX,
      y: currentHeight - imageHeight,
      width: imageWidth,
      height: imageHeight,
    });
    currentHeight -= imageHeight + 40;
  }
  // Add text content
  const paragraphs = text.split("\n");
  for (const paragraph of paragraphs) {
    const lines = paragraph.split(" ").reduce(
      (acc, word) => {
        const lastLine = acc[acc.length - 1];
        const testLine = lastLine ? `${lastLine} ${word}` : word;
        const width = textFont.widthOfTextAtSize(testLine, textFontSize);
        if (width < textWidth) {
          acc[acc.length - 1] = testLine;
        } else {
          acc.push(word);
        }
        return acc;
      },
      [""]
    );

    for (const line of lines) {
      if (currentHeight < margin + lineHeight) {
        addNewPage();
      }
      //if line is empty, skip
      if (line === "") {
        continue;
      }
      currentPage.drawText(line, {
        x: margin,
        y: currentHeight,
        size: textFontSize,
        font: textFont,
        color: rgb(0, 0, 0),
        maxWidth: textWidth,
        lineHeight,
      });
      currentHeight -= lineHeight;
    }
    currentHeight -= lineHeight; // Add extra space between paragraphs
  }

  // Save the PDF
  const pdfBytes = await pdfDoc.save();
  const tempFilePath = path.join(os.tmpdir(), `${Date.now()}_tale.pdf`);

  fs.writeFileSync(tempFilePath, pdfBytes);
  const bucket = storage.bucket(getStorage().bucket().name);
  const filePath = `tales/${uid}/${Date.now()}_tale.pdf`;

  // Upload the file to Firebase Storage
  await bucket.upload(tempFilePath, {
    destination: filePath,
    metadata: {
      metadata: {
        contentType: "application/octet-stream",
      },
    },
  });
  // Get the public URL of the uploaded file
  const file = bucket.file(filePath);
  await file.makePublic();
  const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;

  // Clean up the temporary file
  unlinkSync(tempFilePath);

  return publicUrl;
}

export { createPdf };

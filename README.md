# WordyPDF — Word (DOC/DOCX) to PDF (macOS)

WordyPDF is a simple macOS desktop application that converts Microsoft Word documents (.doc and .docx) to PDF with a single click.

## Key Features

- Convert one or multiple `.doc` / `.docx` files at once
- Choose an output folder for generated PDFs
- Uses the local LibreOffice export engine for offline conversion
- Native macOS UI for a quick and familiar workflow

## Requirements

- macOS (recommended: 10.13 or later)
- LibreOffice installed (WordyPDF uses LibreOffice's PDF export engine)
- Fonts used in the source documents should be installed on the Mac for best rendering results

> Note: On first run, macOS may ask for file access permissions for the app (e.g., Desktop, Documents, selected folders). This is expected.

## Installation

- If you have a prebuilt app bundle, open `Word to PDF.app` by double-clicking it.

- To build from source:

```sh
git clone https://github.com/fikoture/WordyPDF.git
cd WordyPDF
./build.sh
```

After building, the `Word to PDF.app` bundle will be available in the build output directory (for example `dist/`).

## Usage

1. Launch the app (`Word to PDF.app`).
2. Click "Select Files" and pick one or more `.doc` / `.docx` files.
3. Choose the folder where you want the PDFs saved.
4. Click "Convert to PDF".

The app shows progress during conversion and reports when the operation is complete.

## Conversion Engine

WordyPDF relies on the locally installed LibreOffice (soffice) to perform conversions via its export/PDF engine (UNO or command-line interface). Make sure LibreOffice is installed and accessible (e.g., `soffice --version` should run in Terminal).

## Troubleshooting

- Corrupted or unsupported Word files: If LibreOffice cannot open the document, conversion will fail.
- Missing fonts: PDFs may appear with substituted fonts if required fonts are not installed on macOS. Install missing fonts to improve fidelity.
- Permission issues: If the app can't access files or folders, grant access in System Settings → Privacy & Security → Files and Folders.
- LibreOffice not found: Verify LibreOffice is installed and available in PATH, or that the app is configured with the correct LibreOffice path.

## Development

If you modify source code, rebuild with:

```sh
./build.sh
```

Code changes require rebuilding the app bundle to produce a new `Word to PDF.app`.

## Contributing

Issues and feature requests are welcome — please open an Issue. For code changes, fork the repo, create a branch, and submit a Pull Request.

## License

Please add the appropriate license (for example, MIT) to the repository.

---

If you'd like, I can also create a short CHANGELOG entry, add usage screenshots, or open a PR instead of committing directly. Tell me what you prefer.
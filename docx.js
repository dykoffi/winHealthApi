const fs = require('fs')
const { SymbolRun, Table, TableRow, TableCell, TableLayoutType, WidthType, TableAnchorType, RelativeHorizontalPosition, RelativeVerticalPosition, OverlapType, Document, Packer, Paragraph, TextRun, TabStopType, TabStopPosition } = require('docx');
const doc = new Document(
    {
        creator: "Edy koffi",
        subject: "Winhealth facture",
        description: "il s'agit des details d'une facture liée à un séjour dans l'application e-sante winhealth"
    }
);

const table = new Table({
    rows: [
        new TableRow({
            children: [
                new TableCell({
                    children: [new Paragraph({
                        children: [new TextRun("Hey everyone"), new TextRun("\t11th November 1999")],
                        tabStops: [
                            {
                                type: TabStopType.RIGHT,
                                position: TabStopPosition.MAX,
                            },
                        ],
                    })],
                    columnSpan: 2,
                }),
            ],
        }),
        new TableRow({
            children: [
                new TableCell({
                    children: [],
                }),
                new TableCell({
                    children: [],
                }),
            ],
        }),
    ],
    float: {
        horizontalAnchor: TableAnchorType.MARGIN,
        verticalAnchor: TableAnchorType.MARGIN,
        relativeHorizontalPosition: RelativeHorizontalPosition.RIGHT,
        relativeVerticalPosition: RelativeVerticalPosition.BOTTOM,
        overlap: OverlapType.NEVER,
    },
    width: {
        size: 4535,
        type: WidthType.DXA,
    },
    layout: TableLayoutType.FIXED,
});

doc.addSection({
    children: [table],
});
// Used to export the file into a .docx file
Packer.toBuffer(doc).then((buffer) => {
    fs.writeFileSync("Document.docx", buffer);
});
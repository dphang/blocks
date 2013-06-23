include "app://core/constants.ms"
include "app://sprites/block.ms"

// Piece that is composed of multiple blocks
class Piece
{
    const TWO_LINE = 0;
    const THREE_LINE = 1;
    const THREE_L = 2;

    const TWO_LINE_PIECE = [[2], [1]];
    const THREE_LINE_PIECE = [[2], [1], [1]];
    const THREE_L_PIECE = [[2], [1, 1]];

    // Constructor to specify relative grid position of its bottom left piece and its type
    function this(row, col, pieceType)
    {
        super();
        this.row = row;
        this.col = col;
        this.pieceType = pieceType;
    }

    property pieceType(v)
    {
        get return this._pieceType;
        set
        {
            this._pieceType = v;
            switch(v)
            {
                case TWO_LINE:
                    this.blocks = this._makeBlocks(TWO_LINE_PIECE);
                    break;
                case THREE_LINE:
                    this.blocks = this._makeBlocks(THREE_LINE_PIECE);
                    break;
                case THREE_L:
                    this.blocks = this._makeBlocks(THREE_L_PIECE);
                    break;
            }
            this._setAttributes();
        }
    }

    function draw(canvas)
    {
        for (var i = 0; i < this.blocks.length; i++)
        {
            this.blocks[i].draw(canvas);
        }
    }

    // Place the piece in the specified row and column
    function place(row, col)
    {
        var drow = row - this.row;
        var dcol = col - this.col;
        for (var block in this.blocks)
        {
            block.row += drow;
            block.col += dcol;
        }
        this.origin.row += drow;
        this.origin.col += dcol;
        this._setAttributes();
    }

    // Get the piece's rotation as an array of blocks
    function getRotation()
    {
        var tempBlocks = [];
        for (var block in this.blocks)
        {
            tempBlocks.push(new Block(block.row, block.col, block.color));
        }

        for (var block in tempBlocks)
        {
            var col = block.col;
            var row = block.row;

            col -= this.origin.col;
            row -= this.origin.row;

            row = -row;

            var temp = col;
            col = -row;
            row = temp;

            row = -row;

            col += this.origin.col;
            row += this.origin.row;

            block.col = col;
            block.row = row;
        }

        return tempBlocks;
    }

    // Rotate the piece clockwise
    function rotate()
    {
        console.printf("ROTATE\n");
        this.blocks = this.getRotation();
        this._setAttributes();
    }

    // Drop all blocks by the given number of rows
    function drop(rows)
    {
        this.place(this.row - rows, this.col);
    }

    // Move to the side the given number of columns
    function move(cols)
    {
        this.place(this.row, this.col + cols);
    }

    // Check if this piece is selected
    function intersectsPoint(x, y)
    {
        for (var block in this.blocks)
        {
            if (block.intersectsPoint(x, y))
            {
                return true;
            }
        }
        return false;
    }

    // Make the row, col and coordinates of the piece that of the bottom left block
    function _setAttributes()
    {
        this.x = this.blocks[0].x;
        this.y = this.blocks[0].y;
        this.row = this.blocks[0].row;
        this.col = this.blocks[0].col;

        for (var block in this.blocks)
        {
            if (block.x < this.x)
                this.x = block.x;
            if (block.y > this.y)
                this.y = block.y;
            if (block.row > this.row)
                this.row = block.row;
            if (block.col < this.col)
                this.col = block.col;
        }
    }

    // Make the array of Blocks from our piece constant arrays
    function _makeBlocks(pieceArray)
    {
        var blocks = [];
        var color = Block.randomColor();
        var counter = 0;
        for (var row = 0; row < pieceArray.length; row++)
        {
            for (var col = 0; col < pieceArray[row].length; col++)
            {
                var block;
                if (counter == 1)
                {
                    var temp = color;
                    color = Block.randomColor();
                    while (temp == color) // Can't be same color
                    {
                        color = Block.randomColor();
                    }
                }

                switch (pieceArray[row][col])
                {
                    case 2:
                        this.origin = {
                            row: this.row + row,
                            col: this.col + col
                        };
                    case 1:
                        block = new Block(this.row + row, this.col + col, color);
                        blocks.push(block);
                        break;
                }
                counter++;
            }
        }
        return blocks;
    }

    function randomPiece()
    {
        return Math.floor(rand(THREE_L + 1))
    }
}
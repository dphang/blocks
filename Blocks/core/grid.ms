include "app://core/constants.ms"
include "app://sprites/piece.ms"

// Game grid that manages all of the game pieces
class Grid
{
    const DOWN = 0;
    const LEFT = 1;
    const RIGHT = 2;

    const MATCH_MINIMUM = 3;
    // Class variables
    var counter = 0;
    var width = System.width;
    var height = System.height - System.height / 8;

    var rows;
    var cols;

    // Initialize a grid of a specified size and resolution
    function this(rows, cols)
    {
        this.rows = rows;
        this.cols = cols;

        Grid.rows = rows;
        Grid.cols = cols;

        // Initially no piece on the grid
        this.piece = null;

        // Initialize blocks array
        this.blocks = [];
        // Blocks to drop
        this.dropArray = [];
        this.hasMatch = false;
        for (var i = 0, length = this.cols; i < length; i++)
        {
            this.blocks[i] = [];
            for (var j = 0, length = this.rows; j < length; j++)
                this.blocks[i][j] = null;
        }

        this.toClear = false;

    }

    function pointerPressed(x, y)
    {
        this.movePiece = true;
        this.startX = x;
        this.startY = y;

    }

    function pointerDragged(x, y)
    {
        if (x < 0 || x > System.width || y < 0 || y > System.height || this.movePiece == false)
        {
            this.movePiece = false;
            return;
        }
        var piece = this.piece;
        if (piece == null)
        {
            return;
        }
        if (y > this.startY + 50 && !this._overlap(piece.blocks, DOWN)) // Drop one row down
        {
            piece.drop(1);
            this.startY = y;
        }
        else if (x > this.startX + 50 && !this._overlap(piece.blocks, RIGHT)) // Move one column right
        {
            piece.move(1);
            this.startX = x;
        }
        else if (x < this.startX - 50 && !this._overlap(piece.blocks, LEFT)) // Move one column left
        {
            piece.move(-1);
            this.startX = x;
        }
    }

    function pointerReleased(x, y)
    {
        this.movePiece = false;

        if (this.piece == null)
            return;

        var dx = Math.abs(x - this.startX);
        var dy = Math.abs(y - this.startY);
        if (dx <= 10 && dy <= 10)
        {
            var blocks = this.piece.getRotation();

            if (this._overlap(blocks, 10))
            {
                if (!this._overlap(blocks, LEFT))
                {
                    this.piece.move(-1);
                    this.piece.rotate();
                }
                else if (!this._overlap(blocks, RIGHT))
                {
                    this.piece.move(1);
                    this.piece.rotate();
                }
            }
            else
            {
                this.piece.rotate();
            }
        }
    }

    // Process game events
    function onProcess(sender)
    {
        // If there are no pieces, make a piece and clear blocks
        if (this.piece == null)
        {
            this._createPiece();
        }

        // Drop any pieces
        if (Grid.counter % 25 == 0)
        {
            this._dropPieces();
            this._makeBlocks();
        }

        if (this.toClear)
        {
            this._clearBlocks();
            this.toClear = false;
            this.toDrop = true;
        }

        if (this.toDrop)
            this._dropBlocks();

        Grid.counter = Grid.counter + 1;
        if (Grid.counter == 50)
            Grid.counter = 0;
    }

    function draw(canvas)
    {
        for (var col = 0, length = this.blocks.length; col < length; col++)
        {
            for (var row = 0, length = this.blocks[col].length; row < length; row++)
            {
                if (this.blocks[col][row] != null)
                {
                    this.blocks[col][row].draw(canvas);
                }
            }
        }

        if (this.piece != null)
            this.piece.draw(canvas);
    }

    function _createPiece()
    {
        this.piece = new Piece(10, 4, Piece.randomPiece());
        this.movePiece = false;
    }

    function _dropPieces()
    {
        var piece = this.piece;
        if (piece != null)
        {
            if (piece.row == 0 || this._overlap(piece.blocks, DOWN))
            {
                piece.dropped = true;

            }
            else
            {
                piece.drop(1);
            }
        }
    }

    function _makeBlocks()
    {
        var piece = this.piece;
        if (piece != null)
        {
            if (piece.dropped)
            {

                var blocks = piece.blocks;
                for (var block in blocks)
                {
                    var row = block.row;
                    var col = block.col;
                    this.blocks[col][row] = block;;
                }
                this.piece = null;
                this.toClear = true;
            }
        }
    }

    function _buildAllMatches()
    {
        // An array of matches
        var matches = [];
        var checked = [];
        for (var col = 0, length = this.blocks.length; col < length; col++)
        {
            checked[col] = [];
        }
        for (var col = 0, length = this.blocks.length; col < length; col++)
        {
            for (var row = 0, length = this._countActualBlocks(col); row < length; row++)
            {
                if (checked[col].indexOf(row) == -1 && this.blocks[col][row] != null)
                {
                    var match = this._buildMatch(this.blocks[col][row]);
                    // Only push it if the match is greater than length 3
                    if (match.length >= MATCH_MINIMUM)
                        matches.push(match);
                    for (var block in match)
                    {
                        checked[block.col].push(block.row);
                    }
                }
            }
        }

        return matches;
    }

    // Depth first search to build all matches
    function _buildMatch(block)
    {
        var visited = [];
        var stack = [];

        stack.push(block);

        while (stack.length != 0)
        {
            var u = stack.pop();
            if (visited.indexOf(u) == -1)
            {
                visited.push(u);
                for (var v in this._getNeighbors(u))
                {
                    if (v.color == u.color) // To get color matches
                    {
                        stack.push(v);
                    }
                }
            }
        }
        return visited;
    }

    function _getNeighbors(block)
    {
        var neighbors = [];
        for (var row = -1; row <= 1; row += 2)
        {
            var newRow = block.row + row;
            if (newRow >= 0 && newRow < this._countActualBlocks(block.col) && this.blocks[block.col][newRow] != null)
            {
                neighbors.push(this.blocks[block.col][newRow])
            }
        }
        for (var col = -1; col <= 1; col += 2)
        {
            var newCol = block.col + col;
            if (newCol >= 0 && newCol < this.blocks.length && this.blocks[newCol][block.row] != null)
            {
                neighbors.push(this.blocks[newCol][block.row])
            }
        }
        return neighbors;
    }

    // Clear matched blocks
    function _clearBlocks()
    {
        console.printf("clearblocks()\n");
        // Check for matches
        var matches = this._buildAllMatches();

        if (matches.length == 0)
        {
            this.hasMatch = false;
            console.printf("no match\n");
            return;
        }
        else
        {
            console.printf("match\n");
            this.hasMatch = true;
        }

        for (var match in matches)
        {
            for (var block in match)
            {
                this.blocks[block.col][block.row] = null; // Set to null
            }
        }
    }

    function _dropBlocks()
    {
        this.toDrop = false;
        for (var col = 0, length = this.blocks.length; col < length; col++)
        {
            for (var row = 0, length = this.blocks[col].length; row < length; row++)
            {
                var block = this.blocks[col][row];
                if (block != null && !this._overlapBlock(block))
                {
                    this.toDrop = true;
                    this.blocks[block.col][block.row] = null;
                    block.row -= 1;
                    this.blocks[block.col][block.row] = block;
                }
            }
        }
        if (!this.toDrop)
            this._clearBlocks();
            this.toClear = false;
            this.toDrop = true;
    }

    // Check if the given array of blocks overlaps with current landed blocks in a certain direction
    function _overlap(blocks, direction)
    {
        var drow = 0;
        var dcol = 0;

        switch (direction)
        {
            case DOWN:
                drow = -1;
                break;
            case LEFT:
                dcol = -1;
                break;
            case RIGHT:
                dcol = 1;
                break;
            default:
                break;
        }

        for (var block in blocks)
        {

            var newRow = block.row + drow;
            var newCol = block.col + dcol;
            if (newCol < 0 || newCol >= this.blocks.length || newRow < 0 || this.blocks[newCol][newRow] != null)
            {
                return true;
            }
        }
        return false;
    }

    // Check if block overlaps with the block below it
    function _overlapBlock(block)
    {
        var newRow = block.row - 1;
        if (newRow < 0 || this.blocks[block.col][newRow] != null) // Not null i.e. there is a block
        {
            return true;
        }
        return false;
    }

    // Count all blocks in a column that aren't null
    function _countActualBlocks(col)
    {
        var count = 0;
        for (var row = 0, length = this.blocks[col].length; row < length; row++)
        {
            if (this.blocks[col][row] != null)
            {
                count++;
            }
        }
        return count;
    }
}
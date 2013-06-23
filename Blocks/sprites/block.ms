include "lib://game2d/sprite.ms";

// Class for representing a single block
// These come in different colors and are used to build pieces
class Block : Sprite
{
    const RED = 0;
    const BLUE = 1;
    const YELLOW = 2;
    const GREEN = 3;
    const CYAN = 4;
    const PINK = 5;
    const ORANGE = 6;
    const PIECE_SIZE = 96;

    var height = 1000;
    var width = 768;


    function this(row, col, color)
    {
        super();
        this.row = row;
        this.col = col;
        this.color = color;
    }

    property color(v)
    {
        get return this._color;
        set
        {
            this._color = v;
            // Update our image
            switch (this._color)
            {
                case RED:
                    this.image = res.img.red;
                    break;
                case BLUE:
                    this.image = res.img.blue;
                    break;
                case YELLOW:
                    this.image = res.img.yellow;
                    break;
                case GREEN:
                    this.image = res.img.green;
                    break;
                case CYAN:
                    this.image = res.img.cyan;
                    break;
                case PINK:
                    this.image = res.img.pink;
                    break;
                case ORANGE:
                    this.image = res.img.orange;
                    break;
            }
        }
    }

    function init()
    {
        super.init();
        this.frameWidth = PIECE_SIZE;
        this.frameHeight = PIECE_SIZE;
        this.image = res.img.red; // need default image
    }

    property row(v)
    {
        get return this._row;
        set
        {
            this._row = v;
            this.y = System.height - this._row * 96 - 48;
        }
    }

    property col(v)
    {
        get return this._col;
        set
        {
            this._col = v;
            this.x = this._col * 96 + 48;
        }
    }

    function randomColor()
    {
        return Math.floor(rand(3));
    }
}
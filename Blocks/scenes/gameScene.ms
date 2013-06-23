include "lib://game2d/textButton.ms"
include "lib://game2d/label.ms"
include "app://core/grid.ms"

class GameScene : Scene
{
    function init()
    {
        super.init();

        // Initialize new grid
        this.grid = new Grid(20, 8, System.height - System.height/8, System.width);

        // Initialize new score object
        // this._score = new Score();

        // Not paused initially
        this.paused = false;
    }

    function pointerPressed(x, y)
    {
        super.pointerPressed(x, y);

        this.grid.pointerPressed(x, y);
    }

    function pointerReleased(x, y)
    {
        super.pointerReleased(x, y);

        this.grid.pointerReleased(x, y);
    }

    function pointerDragged(x, y)
    {
        super.pointerDragged(x, y);

        this.grid.pointerDragged(x, y);
    }

    function process()
    {
        super.process();

        if (this.paused)
            return;
        this.grid.onProcess(this);

    }

    function draw(canvas)
    {
        canvas.drawBitmapRect(res.img.menuBg, 0, 0, res.img.menuBg.width, res.img.menuBg.height, 0, 0, System.width, System.height);
        this.grid.draw(canvas);

        super.draw(canvas);
    }
}

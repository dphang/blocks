// Class for managing resources
class Resources
{
    // loaded elements (static object)
    var _loaded = {};
    const GFX_PATH = "app://gfx/";
    const SFX_PATH = "app://sfx/";

    var soundEnabled = true;

    function this()
    {
        var self = this;
        this.img = {
            red            : Bitmap.fromFile(GFX_PATH + "red.png"),
            blue           : Bitmap.fromFile(GFX_PATH + "blue.png"),
            green        : Bitmap.fromFile(GFX_PATH + "green.png"),
            pink          : Bitmap.fromFile(GFX_PATH + "pink.png"),
            orange     : Bitmap.fromFile(GFX_PATH + "orange.png"),
            yellow     : Bitmap.fromFile(GFX_PATH + "yellow.png"),
            cyan      : Bitmap.fromFile(GFX_PATH + "cyan.png"),
            menuBg      : Bitmap.fromFile(GFX_PATH + "background_menu.png"),
            board       : Bitmap.fromFile(GFX_PATH + "board.png"),
            newgame     : Bitmap.fromFile(GFX_PATH + "newgame.png"),
            cont        : Bitmap.fromFile(GFX_PATH + "continue.png"),
            options     : Bitmap.fromFile(GFX_PATH + "options.png")
        };
    
        this.resizeButtons();
    
        this.sounds = {
        };

        this.values = {
        }
    }

    function play(file)
    {
        return;
        var audio = new AudioPlayer();
        audio.openFile(file);
        audio.play();
    }

    function resizeButtons()
    {
        console.printf("RESIZE\n");
        var scale = 1.0;
        //if (this.img.cont.width > 4.0 * System.width / 5) {
            //scale = (4.0*System.width / 5) / this.img.cont.width;
            scale = .9;
            this.img.newgame = this.img.newgame.resize((this.img.newgame.width * scale).toInteger(), (this.img.newgame.height * scale).toInteger());
            this.img.cont = this.img.cont.resize((this.img.cont.width * scale).toInteger(), (this.img.cont.height * scale).toInteger());
            this.img.options = this.img.options.resize((this.img.options.width * scale).toInteger(), (this.img.options.height * scale).toInteger());

            this.img.red = this.img.red.resize(96, 96);
        //}
    }

    function loadBg(res)
    {
        if (System.width < 321)
            return Bitmap.fromFile(res + "320x480.jpg");
        else if (System.width < 481)
            return Bitmap.fromFile(res + "480x800.jpg");
        else if (System.width < 601)
            return Bitmap.fromFile(res + "600x800.jpg");
        else if (System.width < 641)
            return Bitmap.fromFile(res + "640x960.jpg");
        else if (System.width < 769)
            return Bitmap.fromFile(res + "768x1024.jpg");
        else
            return Bitmap.fromFile(res + "800x1280.jpg");
    }

    function loadLogo(res)
    {
        if (System.width < 321)
            return Bitmap.fromFile(res + "320x480.png");
        else if (System.width < 481)
            return Bitmap.fromFile(res + "480x800.png");
        else if (System.width < 601)
            return Bitmap.fromFile(res + "600x800.png");
        else if (System.width < 641)
            return Bitmap.fromFile(res + "640x960.png");
        else if (System.width < 769)
            return Bitmap.fromFile(res + "768x1024.png");
        else
            return Bitmap.fromFile(res + "800x1280.png");
    }
}
package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.ui.FlxBar;
import Inventory;

class Obstacle extends FlxSprite{
	public var life:Int;
	public var damage:Int;
    public var greenBar:FlxBar;
    private var maxlife:Float;

    public static inline var WIDTHBAR = 16;
    public static inline var HEIGHBAR = 4;

    public function new(x:Float, y:Float, sizeX:Int, sizeY: Int, life:Int, damage:Int, item:Item, sprite:FlxSprite, angle:Float, invItem:Bool) {
        super(x, y);
        setSize(sizeX,sizeY);
        this.maxlife=life; 
        this.life = life;
        this.damage=damage;
        immovable=true;
        this.angle = angle;

        greenBar = new FlxBar(x, y - 12, LEFT_TO_RIGHT, WIDTHBAR, HEIGHBAR);
        greenBar.createFilledBar(FlxColor.RED, FlxColor.BLUE, true, FlxColor.TRANSPARENT);
        greenBar.numDivisions = 5000;
        greenBar.value = 100;

        if(invItem) {
            if(item == Item.STONE_WALL) {
                loadGraphic(AssetPaths.sprites__png, true, 32, 32);
                animation.add("obstacle", [26], 8);
                animation.play("obstacle");
            }
            else if(item == Item.WOOD_BARRICADE) {
                  loadGraphic(AssetPaths.sprites__png, true, 32, 32);
                animation.add("obstacle", [25], 8);
                animation.play("obstacle");
            }
            else if(item == Item.WOOD_WALL) {
                  loadGraphic(AssetPaths.sprites__png, true, 32, 32);
                animation.add("obstacle", [24], 8);
                animation.play("obstacle");
            }
        }
        else {
            makeGraphic(sizeX, sizeY, FlxColor.GRAY);
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function getHit(damage:Int){
    	life -= damage;
        greenBar.value = life * 100 / maxlife;
    }
}
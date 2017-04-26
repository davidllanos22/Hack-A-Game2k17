package;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import Math;
import Inventory;

class DropedItem extends FlxSprite{
	public var item:Item;

	public function new (x: Float, y: Float){
		super(x, y);
		loadGraphic(AssetPaths.tiles__png, true, 16, 16);
		var rand=new FlxRandom();
		var type=rand.int(0,1);
		switch (type) {
			case 0:
			item=Item.STONE;
        	animation.add("drop", [16], 8);//roca

			case 1:
			item=Item.WOOD;
        	animation.add("drop", [17], 8);//madera
		}
		setSize(16,16);
		
        animation.play("drop");
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);	
		
	}
}
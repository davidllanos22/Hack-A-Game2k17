package;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import Std;
import Inventory;

class CraftMenu extends FlxSubState{
	
	public var inventory:Inventory;
	public var playState:PlayState;

	public var text1:FlxText;
	public var text2:FlxText;

	public var craftButton:FlxButton;
	public var equipButton:FlxButton;
	public var placeButton:FlxButton;
	public var waveButton:FlxButton;

	public var textBasic1:FlxText;
	public var textBasic2:FlxText;
	public var textBasic3:FlxText;
	public var textBasic4:FlxText;
	public var textBasic5:FlxText;
	public var textBasic6:FlxText;
	public var textBasic7:FlxText;
	public var textBasic8:FlxText;
	public var textBasic9:FlxText;

	public var textCraft1:FlxText;
	public var textCraft2:FlxText;
	public var textCraft3:FlxText;

	public var textEquip1:FlxText;
	public var textEquip2:FlxText;

	public var sB1:FlxButton;
	public var sB2:FlxButton;
	public var sB3:FlxButton;

	public var csel:Int;

	public function new(inventory:Inventory, playState:PlayState, color:FlxColor):Void 
	{
		super(color);

		this.inventory = inventory;
		this.playState = playState;

		FlxG.camera.x = 0;
		FlxG.camera.y = 0;

		csel = -1;
	}
	
	override public function create():Void {
		text1 = new FlxText(30,0,144,"Basic Items",10);
		text1.color = FlxColor.BLUE;
		text2 = new FlxText(174,0,144,"Craftables",10);
		text2.color = FlxColor.BLUE;

		text1.scrollFactor.set(0,0);
		text2.scrollFactor.set(0,0);

		craftButton = new FlxButton(318,0,"Craft", craft);
		equipButton = new FlxButton(318,80,"Equip", equip);
		placeButton = new FlxButton(318,40,"Place", place);
		waveButton = new FlxButton(318,174,"Next Wave", newtWave);
		sB1 = new FlxButton(174,27,"",select1);
		sB2 = new FlxButton(174,51,"",select2);
		sB3 = new FlxButton(174,75,"",select3);
		
	 	textBasic1 = new FlxText(30, 27, 144, "Water x " + inventory.getQuantity(Item.WATER), 8); 
		textBasic2 = new FlxText(30, 51, 144, "Wood x " + inventory.getQuantity(Item.WOOD), 8); 
		textBasic3 = new FlxText(30, 75, 144, "Mud x " + inventory.getQuantity(Item.MUD), 8); 
		textBasic4 = new FlxText(30, 99, 144, "Stone x " + inventory.getQuantity(Item.STONE), 8); 
		textBasic5 = new FlxText(30, 123, 144, "Glass x " + inventory.getQuantity(Item.GLASS), 8); 
		textBasic6 = new FlxText(30, 147, 144, "Alcohol x " + inventory.getQuantity(Item.ALCOHOL), 8); 
		textBasic7 = new FlxText(30, 171, 144, "Rag x " + inventory.getQuantity(Item.RAG), 8); 
		textBasic8 = new FlxText(30, 195, 144, "Coal x " + inventory.getQuantity(Item.COAL), 8); 
		textBasic9 = new FlxText(30, 219, 144, "Gunpowder x " + inventory.getQuantity(Item.GUNPOWDER), 8); 
	
		textBasic1.scrollFactor.set(0,0);
		textBasic2.scrollFactor.set(0,0);
		textBasic3.scrollFactor.set(0,0);
		textBasic4.scrollFactor.set(0,0);
		textBasic5.scrollFactor.set(0,0);
		textBasic6.scrollFactor.set(0,0);
		textBasic7.scrollFactor.set(0,0);
		textBasic8.scrollFactor.set(0,0);
		textBasic9.scrollFactor.set(0,0);

		textCraft1 = new FlxText(174, 27, 120, "Stone Wall x " + inventory.getQuantity(Item.STONE_WALL), 8);
		textCraft2 = new FlxText(174, 51, 120, "Barricade x " + inventory.getQuantity(Item.WOOD_BARRICADE), 8);
		textCraft3 = new FlxText(174, 75, 120, "Wooden Wall x " + inventory.getQuantity(Item.WOOD_WALL),8);

		textCraft1.scrollFactor.set(0,0);
		textCraft2.scrollFactor.set(0,0);
		textCraft3.scrollFactor.set(0,0);

		textEquip1 = new FlxText(318, 120, 120, "Molotov x ", 8);
		textEquip2 = new FlxText(318, 144, 120, "Grenade x ", 8);

		textEquip1.scrollFactor.set(0,0);
		textEquip2.scrollFactor.set(0,0);

		add(text1);
		add(text2);
		add(craftButton);
		add(equipButton);
		add(placeButton);
		add(waveButton);
		add(textBasic1);
		add(textBasic2);
		add(textBasic3);
		add(textBasic4);
		add(textBasic5);
		add(textBasic6);
		add(textBasic7);
		add(textBasic8);
		add(textBasic9);
		add(textCraft1);
		add(textCraft2);
		add(textCraft3);
		add(textEquip1);
		add(textEquip2);
		add(sB1);
		add(sB2);
		add(sB3);
		sB1.alpha = 0;
		sB2.alpha = 0;
		sB3.alpha = 0;

		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);
		//sB1.scale.x = sB1.scale.y = 1/4;
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);

		textBasic1.text = "Water x " + inventory.getQuantity(Item.WATER);
		textBasic2.text = "Wood x " + inventory.getQuantity(Item.WOOD); 
		textBasic3.text = "Mud x " + inventory.getQuantity(Item.MUD); 
		textBasic4.text = "Stone x " + inventory.getQuantity(Item.STONE); 
		textBasic5.text = "Glass x " + inventory.getQuantity(Item.GLASS); 
		textBasic6.text = "Alcohol x " + inventory.getQuantity(Item.ALCOHOL); 
		textBasic7.text = "Rag x " + inventory.getQuantity(Item.RAG); 
		textBasic8.text = "Coal x " + inventory.getQuantity(Item.COAL); 
		textBasic9.text = "Gunpowder x " + inventory.getQuantity(Item.GUNPOWDER); 
		textCraft1.text = "Stone Wall x " + inventory.getQuantity(Item.STONE_WALL);
		textCraft2.text = "Barricade x " + inventory.getQuantity(Item.WOOD_BARRICADE);
		textCraft3.text = "Wooden Wall x " + inventory.getQuantity(Item.WOOD_WALL);
	}

	public function craft():Void {
		switch csel{
			
			case -1:
			case 0: 
				inventory.createItem(Item.STONE_WALL);
				select1();
			case 1:
				inventory.createItem(Item.WOOD_BARRICADE);
				select2();
			case 2:
				inventory.createItem(Item.WOOD_WALL);
				select3();
		}
	}

	public function equip():Void {

	}

	public function placeSW():Void {
		playState.placeSW();
		close();
	}

	public function placeWB():Void {
		playState.placeWB();
		close();
	}

	public function placeWW():Void {
		playState.placeWW();
		close();
	}

	public function newtWave():Void {
		playState.putObject = false;
		playState.startWave();
		FlxG.sound.playMusic(AssetPaths.battle__wav, 0.5, true);
		playState.button1.text = "Shoot";
		playState.button2.text = "SubWeapon";
		playState.button1.active = true;
		playState.button1.alpha = 1;
		playState.button2.active = true;
		playState.button1.alpha = 1;
		close();

	}

	public function select1():Void{
		textCraft1.color = FlxColor.RED;
		textCraft2.color = FlxColor.WHITE;
		textCraft3.color = FlxColor.WHITE;
		csel = 0;

		if (inventory.canCreate(Item.STONE_WALL)){
			craftButton.alpha = 1;
			craftButton.active = true;
		}else{
			craftButton.alpha = 0.3;
			craftButton.active = false;
		}

		if(inventory.getQuantity(Item.STONE_WALL) > 0) {
			placeButton.alpha = 1;
			placeButton.active = true;
		}
		else{
			placeButton.alpha = 0.3;
			placeButton.active = false;
		}
		equipButton.alpha = 0.3;
		equipButton.active = false;
	}

	public function select2():Void{
		textCraft2.color = FlxColor.RED;
		textCraft1.color = FlxColor.WHITE;
		textCraft3.color = FlxColor.WHITE;
		csel = 1;

		if (inventory.canCreate(Item.WOOD_BARRICADE)){
			craftButton.alpha = 1;
			craftButton.active = true;
		}else{
			craftButton.alpha = 0.3;
			craftButton.active = false;
		}

		if(inventory.getQuantity(Item.WOOD_BARRICADE) > 0) {
			placeButton.alpha = 1;
			placeButton.active = true;
		}
		else{
			placeButton.alpha = 0.3;
			placeButton.active = false;
		}
		equipButton.alpha = 0.3;
		equipButton.active = false;
	}

	public function select3():Void{
		textCraft3.color = FlxColor.RED;
		textCraft1.color = FlxColor.WHITE;
		textCraft2.color = FlxColor.WHITE;
		csel = 2; 
		if (inventory.canCreate(Item.WOOD_WALL)){
			craftButton.alpha = 1;
			craftButton.active = true;
		}else{
			craftButton.alpha = 0.3;
			craftButton.active = false;
		}

		if(inventory.getQuantity(Item.WOOD_WALL) > 0) {
			placeButton.alpha = 1;
			placeButton.active = true;
		}
		else{
			placeButton.alpha = 0.3;
			placeButton.active = false;
		}
		equipButton.alpha = 0.3;
		equipButton.active = false;
	}

	public function place():Void {
		if(sB1.active) {
			placeSW();
		}
		else if(sB2.active) {
			placeWB();
		}
		else if(sB3.active) {
			placeWW();
		}
	}

}

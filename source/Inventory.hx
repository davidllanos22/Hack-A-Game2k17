package;


enum Item{
	WATER;
	WOOD;
	MUD;
	STONE;
	GLASS;
	ALCOHOL;
	RAG;
	COAL;
	GUNPOWDER;
//Craftable
	WOOD_WALL;
	STONE_WALL;
	WOOD_BARRICADE;
}

class Inventory {

	public var items:Map<Item,Int>;

	public function new(){
		items = [
		Item.WATER=>0,
		Item.WOOD=>0,
		Item.MUD=>0,
		Item.STONE=>0,
		Item.GLASS=>0,
		Item.ALCOHOL=>0,
		Item.RAG=>0,
		Item.COAL=>0,
		Item.GUNPOWDER=>0,
		//Craftables
		Item.WOOD_WALL=>0,
		Item.STONE_WALL=>0,
		Item.WOOD_BARRICADE=>0,
    ];
	}

	public function addItem(item:Item){
		items[item]+=1;
	}

	/*public function createItem(it:Item){
		switch it {
			case Item.WOOD_WALL:
				items[Item.WOOD]-=1;
		}
	}*/
	
}
package core.terrain.tmx
{
	/**
	 * Fixed two directional int vector 
	 * + using single vector math for performance
	 * @author Jonathan Dunlap
	 */
	public class GridInt 
	{
		private var data:Vector.<int>;
		private var width:int=0;
		private var height:int=0;
		/**
		 * Constructor 
		 * @param width number of cells wide
		 * @param height number of cells heigh
		 * 
		 */		
		public function GridInt(width:int, height:int) 
		{
			this.width = width;
			this.height = height;
			if (width == 0 && height == 0) throw new Error("Invalid starting size of 0,0");
			width = Math.max(width, 1); // ensure that it's not zero as an example of 0 width times 1 height would be zero
			height = Math.max(height, 1); // same here
			data = new Vector.<int>(width * height, true); // make a prefined fixed sized array for performance
		}
		/**
		 * Pretty string of the grid 
		 * @return string showing the grid layout
		 * 
		 */		
		public function toString():String {
			var result:String = "";
			for (var y:int = 0; y < height; y++) {
				for (var x:int = 0; x < width; x++) {
					result += getCell(x, y).toString();
				}
				result += "\n";
			}	
			return result; 
		}
		/**
		 * Gets an int from a cell location 
		 * @param x cell x location
		 * @param y cell y location
		 * @return int of that cell
		 * 
		 */		
		public function getCell(x:int, y:int):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index];
		}
		/**
		 * Sets an int for a cell location 
		 * @param x cell x location
		 * @param y cell y location
		 * @param int value for that cell location
		 * @return cell's new int value
		 * 
		 */
		public function setCell(x:int, y:int, value:int):int {
			var index:int = y * width + x; // get the index of the single array for the grid position
			return data[index] = value;
		}
	}
}
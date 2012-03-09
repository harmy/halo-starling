/* IsoHill engine, http://www.isohill.com
* Copyright (c) 2011, Jonathan Dunlap, http://www.jadbox.com
* All rights reserved. Licensed: http://www.opensource.org/licenses/bsd-license.php
* 
* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*/
package core.terrain.tmx
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import GridInt;
	import core.utils.Base64;

	/**
	 * Represents a TMX layer of ints
	 * @author Jonathan Dunlap
	 */
	public class TMXLayer extends GridInt
	{
		public var maxGid:int = 0; // what's the highest asset id referenced
		public var name:String;
		public function TMXLayer(w:int, h:int) 
		{
			super(w, h);
		}
		public static function fromCSV(layerBlock:XML, width:int, height:int):TMXLayer {
			var layerRaw:Array = layerBlock.data[0].toString().split(",");

			var layer:TMXLayer = new TMXLayer(width, height);
			var index:int = 0;
			for each(var cell:String in layerRaw) {
					cell = cell.replace("\n", ""); // remove those line breaks in the cvs data
					var cellVal:int = int(cell);
					layer.maxGid = Math.max(layer.maxGid, cellVal);
					layer.setCell(index % width, Math.floor(index / width), cellVal);
					index++;
			}
			trace("csv layer parsing done");
			return layer;
		}
		
		public static function fromBase64(chunk:String, width:int, height:int, compressed:Boolean):TMXLayer
		{
			var result:TMXLayer = new TMXLayer(width, height);
			var data:ByteArray = Base64.base64ToByteArray(chunk);
			if(compressed)
				data.uncompress();
			data.endian = Endian.LITTLE_ENDIAN;
			var y:int = 0;
			while(data.position < data.length)
			{
				for (var x:int = 0; x < width; x++) {
					var val:int = data.readInt();
					result.setCell(x, y, val);
					result.maxGid = Math.max(val, result.maxGid);
				}
				y++;
			}
			return result;
		}
	}

}

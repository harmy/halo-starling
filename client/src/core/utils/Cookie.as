package core.utils
{
	import flash.net.SharedObject;

	public class Cookie
	{
		private var m_name:String;
		private var m_sharedObj:SharedObject;
		
		public function Cookie(name:String = "System")
		{
			this.name = name;
			//m_name = name;
			//m_sharedObj = SharedObject.getLocal(m_name,"/zscs");
		}
		
		public function get name():String
		{
			return m_name;
		}
		
		public function set name(value:String):void
		{
			m_name = value;
			m_sharedObj = SharedObject.getLocal("zscs/" + m_name);
		}
		
		public function write(key:String, value:*, flush:Boolean = true):void
		{
			if (m_sharedObj.data.cookie == undefined) {
				var obj:Object = {};
				obj[key] = value;
				m_sharedObj.data.cookie = obj;
			} else {
				m_sharedObj.data.cookie[key] = value;
			}
			
			try {
				if (flush) {
					m_sharedObj.flush();
				}	
			} catch (err:Error) {
				trace(err.message);				
			}
		}
		
		public function read(key:String):*
		{
			return isExist(key) ? m_sharedObj.data.cookie[key] : null;
		}
		
		public function isExist(key:String):Boolean
		{
			if (m_sharedObj.data.cookie == undefined)
				return false;
			
			if (m_sharedObj.data.cookie[key] == undefined)
				return false;
			
			return true;
		}
		
		public function remove(key:String):void
		{
			if (!isExist(key))
				return;
			
			delete m_sharedObj.data.cookie[key];
			m_sharedObj.flush();
		}
		
		public function clear():void
		{
			m_sharedObj.clear();
		}
		
	}
}



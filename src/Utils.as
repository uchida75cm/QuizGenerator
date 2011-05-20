package {
	import flash.text.TextFormat;
	
	public class Utils {
		public static function getCommonFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 48;
			format.font = "Arial";
			return format;
		}
		
		public static function getTitleFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 100;
			format.font = "Arial";
			format.color = "0x333333";
			format.bold = true;
			return format;
		}
		
		public static function getOrangeFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 65;
			format.font = "Arial";
			//format.color = "0xFF6500";
			format.color = "0x333333";
			format.bold = true;
			return format;
		}
		
		public static function getBlueFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 65;
			format.font = "Arial";
			//format.color = "0x00CBFF";
			format.color = "0x333333";
			format.bold = true;
			return format;
		}
		
		public static function getGreenFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 65;
			format.font = "Arial";
			//format.color = "0x66DA12";
			format.color = "0x333333";
			format.bold = true;
			return format;
		}
		
		public static function getYellowFormat(): TextFormat {
			var format = new TextFormat();
			format.size = 65;
			format.font = "Arial";
			//format.color = "0xFFDE20";
			format.color = "0x333333";
			format.bold = true;
			return format;
		}
	}
	
}
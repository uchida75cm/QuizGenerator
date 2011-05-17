/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.utils {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">XMLUtil クラスは、XML 操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The XMLUtil class is an utility class for XML operation.</span>
	 */
	public final class XMLUtil {
		
		/**
		 * @private
		 */
		public function XMLUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定された XMLList インスタンスのオブジェクト表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @param xmllist
		 * <span lang="ja">変換したい XMLList インスタンスです。</span>
		 * <span lang="en">The XMLList instance to convert.</span>
		 * @return
		 * <span lang="en">XMLList インスタンスのオブジェクト表現です。</span>
		 * <span lang="en">A Object representation of the XMLList instance.</span>
		 * 
		 * @example <listing version="3.0">
		 * var xml:XMLList = new XMLList( ""
		 * 	+ "<aaa>AAA</aaa>"
		 * 	+ "<bbb>BBB</bbb>"
		 * 	+ "<ccc>CCC</ccc>" );
		 * var obj:Object = XMLUtil.xmlToObject( xml );
		 * trace( obj.aaa ); // AAA を出力します。
		 * trace( obj.bbb ); // BBB を出力します。
		 * trace( obj.ccc ); // CCC を出力します。
		 * </listing>
		 */
		public static function xmlToObject( xmllist:XMLList ):Object {
			var o:Object = {};
			
			for each ( var xml:XML in xmllist ) {
				o[String( xml.name() )] = StringUtil.toProperType( xml.valueOf(), false );
			}
			
			return o;
		}
	}
}

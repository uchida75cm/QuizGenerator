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
	import flash.text.TextField;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">TextFieldUtil クラスは、TextField 操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The TextFieldUtil class is an utility class for TextField operation.</span>
	 */
	public final class TextFieldUtil {
		
		/**
		 * @private
		 */
		public function TextFieldUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">対象の TextField に設定されているテキストが、フィールドの表示領域内に収まるように切り抜きます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param textField
		 * <span lang="ja">切り抜きたい TextField インスタンスです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function clip( textField:TextField ):void {
			if ( textField.maxScrollH > 0 ) {
				textField.appendText( "..." );
				
				while ( textField.maxScrollH > 0 ) {
					var words:Array = textField.text.split( "" );
					words.splice( words.length - 4, 1);
					textField.text = words.join( "" );
				}
			}
		}
	}
}

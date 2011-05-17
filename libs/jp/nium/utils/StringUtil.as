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
	 * <span lang="ja">StringUtil クラスは、文字列操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The StringUtil class is an utility class for string operation.</span>
	 */
	public final class StringUtil {
		
		/**
		 * 改行コードを判別する正規表現を取得します。
		 */
		private static const _COLLECTBREAK_REGEXP:String = "(\r\n|\r|\n)";
		
		
		
		
		
		/**
		 * @private
		 */
		public function StringUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたストリングを適切な型のオブジェクトに変換して返します。</span>
		 * <span lang="en">Convert the specified string to the proper object type and returns.</span>
		 * 
		 * @param str
		 * <span lang="ja">変換したいストリングです。</span>
		 * <span lang="en">The string to convert.</span>
		 * @param priority
		 * <span lang="ja">数値化を優先するかどうかです。</span>
		 * <span lang="en">Whether it gives priority to expressing numerically or not?</span>
		 * @return
		 * <span lang="ja">変換後のオブジェクトです。</span>
		 * <span lang="en">The converted object.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function toProperType( str:String, priority:Boolean = false ):* {
			// Number 型に変換する
			var num:Number = parseFloat( str );
			
			// モードが true なら
			if ( priority ) {
				// 数値化を優先する
				if ( !isNaN( num ) ) { return num; }
			}
			else {
				// 元データの維持を優先する
				if ( num.toString() == str ) { return num; }
			}
			
			// グローバル定数、プライマリ式キーワードで返す
			switch ( str ) {
				case "true"			: { return true; }
				case "false"		: { return false; }
				case ""				:
				case "null"			: { return null; }
				case "undefined"	: { return undefined; }
				case "Infinity"		: { return Infinity; }
				case "-Infinity"	: { return -Infinity; }
				case "NaN"			: { return NaN; }
			}
			
			return str;
		}
		
		/**
		 * <span lang="ja">指定された文字列を指定された数だけリピートさせた文字列を返します。</span>
		 * <span lang="en">Returns the string which repeats the specified string with specified times.</span>
		 * 
		 * @param str
		 * <span lang="ja">リピートしたい文字列です。</span>
		 * <span lang="en">The string to repeat.</span>
		 * @param count
		 * <span lang="ja">リピート回数です。</span>
		 * <span lang="en">Repeat time.</span>
		 * @return
		 * <span lang="ja">リピートされた文字列です。</span>
		 * <span lang="en">Repeated string.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function repeat( str:String, count:int = 0 ):String {
			var result:String = "";
			for ( var i:int = 0, l:int = count; i < l; i++ ) {
				result += str;
			}
			return result;
		}
		
		/**
		 * <span lang="ja">全ての改行コードを削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param str
		 * <span lang="ja">全ての改行コードを削除したいストリングです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">全ての改行コードが削除された後のストリングです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function ignoreBreak( str:String ):String {
			return str.split( "\r" ).join( "" ).split( "\n" ).join( "" );
		}
		
		/**
		 * <span lang="ja">String の最初の文字を大文字にし、以降の文字を小文字に変換して返します。</span>
		 * <span lang="en">Convert the first character to upper case and remain character to lower case of the specified string.</span>
		 * 
		 * @param str
		 * <span lang="ja">変換したい文字列です。</span>
		 * <span lang="en">The string to convert.</span>
		 * @return
		 * <span lang="ja">変換後の文字列です。</span>
		 * <span lang="en">The converted string.</span>
		 * 
		 * @example <listing version="3.0" >
		 * </listing>
		 */
		public static function toUpperCaseFirstLetter( str:String ):String {
			return str.charAt( 0 ).toUpperCase() + str.slice( 1 ).toLowerCase();
		}
		
		/**
		 * <span lang="ja">改行コードを変換して返します。</span>
		 * <span lang="en">Convert the line feed code of the specified string and returns.</span>
		 * 
		 * @param str
		 * <span lang="ja">変換したい文字列です。</span>
		 * <span lang="en">The string to convert.</span>
		 * @param newLine
		 * <span lang="ja">変換後の改行コードです。</span>
		 * <span lang="en">The line feed code to convert to.</span>
		 * @return
		 * <span lang="ja">変換後の文字列です。</span>
		 * <span lang="en">The converted string.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function collectBreak( str:String, newLine:String = null ):String {
			return str.replace( new RegExp( _COLLECTBREAK_REGEXP, "g" ), newLine || "\n" );
		}
		
		/**
		 * <span lang="ja">ストリングが指定文字数で収まるように、前後を残して中央部分を削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param str
		 * <span lang="ja">変換したい文字列です。</span>
		 * <span lang="en">The string to convert.</span>
		 * @param length
		 * <span lang="ja">整形後の文字数です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">変換後の文字列です。</span>
		 * <span lang="en">The converted string.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function clip( str:String, length:int ):String {
			if ( str.length <= length ) { return str; }
			
			length = Math.max( 0, length - 3 );
			var keepLength:int = Math.floor( length / 2 );
			
			var s:String = str.substr( 0, keepLength );
			var e:String = str.substr( str.length - keepLength, keepLength );
			
			return s + "..." + e;
		}
	}
}

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
	import flash.utils.ByteArray;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * <span lang="ja">ObjectUtil クラスは、オブジェクト操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The ObjectUtil class is an utility class for object operation.</span>
	 */
	public final class ObjectUtil {
		
		/**
		 * @private
		 */
		public function ObjectUtil() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">対象オブジェクトのプロパティを一括設定します。</span>
		 * <span lang="en">Set the whole property of the object.</span>
		 * 
		 * @param target
		 * <span lang="ja">一括設定したいオブジェクトです。</span>
		 * <span lang="en">The object to set.</span>
		 * @param props
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en">The object that contains the property to setup.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function setProperties( target:Object, parameters:Object ):void {
			if ( target is Array ) {
				var targets:Array = target as Array;
			}
			else {
				targets = [ target ];
			}
			
			// プロパティを設定する
			for ( var i:int = 0, l:int = targets.length; i < l; i++ ) {
				for ( var parameter:String in parameters ) {
					// プロパティが存在しなければ次へ
					if ( !( parameter in targets[i] ) ) { continue; }
					
					// プロパティを設定する
					targets[i][parameter] = parameters[parameter];
				}
			}
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトを複製して返します。</span>
		 * <span lang="en">Returns the copy of the specified object.</span>
		 * 
		 * @param target
		 * <span lang="ja">対象のオブジェクトです。</span>
		 * <span lang="en">The object to copy.</span>
		 * @return
		 * <span lang="ja">複製されたオブジェクトです。</span>
		 * <span lang="en">The copied object.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function clone( target:Object ):Object {
			var byte:ByteArray = new ByteArray();
			byte.writeObject( target );
			byte.position = 0;
			return Object( byte.readObject() );
		}
		
		/**
		 * <span lang="ja">シンプルな toString() メソッドの実装を提供します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param target
		 * <span lang="ja">実装したい対象です。</span>
		 * <span lang="en"></span>
		 * @param className
		 * <span lang="ja">対象のクラス名です。</span>
		 * <span lang="en"></span>
		 * @param args
		 * <span lang="ja">出力に反映させたいプロパティ名です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">生成されるストリングです。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function formatToString( target:*, className:String, ... args:Array ):String {
			var str:String = "[object " + className;
			
			for ( var i:int = 0, l:int = args.length; i < l; i++ ) {
				var name:String = args[i];
				
				if ( !name ) { continue; }
				
				str += " " + name + "=";
				
				var value:* = target[name];
				
				if ( value is String ) {
					str += "\"" + value + "\"";
				}
				else {
					str += value;
				}
			}
			
			return str += "]";
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのクエリーストリング表現を返します。</span>
		 * <span lang="en">Returns the query string expression of the specified object.</span>
		 * 
		 * @param query
		 * <span lang="ja">対象のオブジェクトです。</span>
		 * <span lang="en">The object to get the query string.</span>
		 * @return
		 * <span lang="ja">オブジェクトのクエリーストリング表現です。</span>
		 * <span lang="en">The query string expression of the object.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function toQueryString( query:Object ):String {
			// 存在しなければ終了する
			if ( !query ) { return ""; }
			
			// String に変換する
			var str:String = "";
			for ( var p:String in query ) {
				str += p + "=" + query[p] + "&";
			}
			
			// 1 度でもループを処理していれば、最後の & を削除する
			if ( p ) {
				str = str.slice( 0, -1 );
			}
			
			return encodeURI( decodeURI( str ) );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string expression of the specified object.</span>
		 * 
		 * @param target
		 * <span lang="ja">対象のオブジェクトです。</span>
		 * <span lang="en">The object to get the string expression.</span>
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">The string expression of the object.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function toString( target:Object ):String {
			if ( target is Array ) { return ArrayUtil.toString( target as Array ); }
			
			var str:String = "{";
			
			for ( var p:String in target ) {
				str += p + ":";
				
				var value:* = target[p];
				
				switch ( true ) {
					case value is Array		: { str += ArrayUtil.toString( value ); break; }
					case value is Boolean	:
					case value is Number	:
					case value is int		:
					case value is uint		: { str += value; break; }
					case value is String	: { str += '"' + value.replace( new RegExp( '"', "gi" ), '\\"' ) + '"'; break; }
					default					: { str += toString( value ); }
				}
				
				str += ", ";
			}
			
			// 1 度でもループを処理していれば最後の , を削除する
			if ( p ) {
				str = str.slice( 0, -2 );
			}
			
			str += "}";
			
			return str;
		}
	}
}

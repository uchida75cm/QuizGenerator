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
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	
	/**
	 * <span lang="ja">ClassUtil クラスは、クラス操作のためのユーティリティクラスです。</span>
	 * <span lang="en">The ClassUtil class is an utility class for class operation.</span>
	 */
	public final class ClassUtil {
		
		/**
		 * @private
		 */
		nium_internal static var $DEFAULT_CLASS_NAME:String = "Uninitialized Object";
		
		/**
		 * クラス名を保持した Dictionary インスタンスを取得します。 
		 */
		private static var _classStrings:Dictionary = new Dictionary( true );
		
		
		
		
		
		/**
		 * @private
		 */
		public function ClassUtil() {
			// クラスをコンパイルに含める
			nium_internal;
			
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		nium_internal static function $getClassString( target:* ):StringObject {
			var className:String = getClassName( target );
			return _classStrings[className] ||= new StringObject( className );
		}
		
		/**
		 * <span lang="ja">対象のクラス名を返します。</span>
		 * <span lang="en">Returns the class name of the object.</span>
		 * 
		 * @param target
		 * <span lang="ja">クラス名を取得する対象です。</span>
		 * <span lang="en">The object to get the class name.</span>
		 * @return
		 * <span lang="ja">クラス名です。</span>
		 * <span lang="en">The class name.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getClassName( target:* ):String {
			return getQualifiedClassName( target ).split( "::" ).pop();
		}
		
		/**
		 * <span lang="ja">対象のクラスパスを返します。</span>
		 * <span lang="en">Returns the class path of the object.</span>
		 * 
		 * @param target
		 * <span lang="ja">クラスパスを取得する対象です。</span>
		 * <span lang="en">The class path of the object.</span>
		 * @return
		 * <span lang="ja">クラスパスです。</span>
		 * <span lang="en">The class path.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getClassPath( target:* ):String {
			return getQualifiedClassName( target ).replace( new RegExp( "::", "g" ), "." );
		}
		
		/**
		 * <span lang="ja">対象のパッケージを返します。</span>
		 * <span lang="en">Returns the package of the object.</span>
		 * 
		 * @param target
		 * <span lang="ja">パッケージを取得する対象です。</span>
		 * <span lang="en">The object to get the package.</span>
		 * @return
		 * <span lang="ja">パッケージです。</span>
		 * <span lang="en">The package.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function getPackage( target:* ):String {
			return getQualifiedClassName( target ).split( "::" ).shift();
		}
		
		/**
		 * <span lang="ja">対象のクラスに dynamic 属性が設定されているかどうかを返します。</span>
		 * <span lang="en">Returns if the dynamic attribute is set to the class object.</span>
		 * 
		 * @param target
		 * <span lang="en">dynamic 属性の有無を調べる対象です。</span>
		 * <span lang="en">The object to check if the dynamic attribute is set or not.</span>
		 * @return
		 * <span lang="en">dynamic 属性があれば true を、違っていれば false を返します。</span>
		 * <span lang="en">Returns true if dynamic attribute is set, otherwise return false.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function isDynamic( target:* ):Boolean {
			return Boolean( StringUtil.toProperType( describeType( target ).attribute( "isDynamic" ) ) );
		}
		
		/**
		 * <span lang="ja">対象のクラスに final 属性が設定されているかどうかを返します。</span>
		 * <span lang="en">Returns if the final attribute is set to the class object.</span>
		 * 
		 * @param target
		 * <span lang="en">final 属性の有無を調べる対象です。</span>
		 * <span lang="en">The object to check if the final attribute is set or not.</span>
		 * @return
		 * <span lang="en">final 属性があれば true を、違っていれば false を返します。</span>
		 * <span lang="en">Returns true if final attribute is set, otherwise return false.</span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function isFinal( target:* ):Boolean {
			return Boolean( StringUtil.toProperType( describeType( target ).attribute( "isFinal" ) ) );
		}
		
		/**
		 * <span lang="ja">対象のインスタンスが指定されたクラスを継承しているかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param target
		 * <span lang="ja">継承関係を調査したいインスタンスです。</span>
		 * <span lang="en"></span>
		 * @param cls
		 * <span lang="ja">継承関係を調査委したいクラスです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">継承されていれば true を、それ以外の場合には false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function isExtended( target:*, cls:Class ):Boolean {
			return Object( target ).constructor == cls;
		}
	}
}

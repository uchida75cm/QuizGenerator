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
package jp.nium.core.L10N {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * @private
	 */
	public dynamic class L10NMsg extends Proxy {
		
		/**
		 * @private
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NMsg() {
			// クラスをコンパイルに含める
			nium_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
		}
		
		
		
		
		
		
		/**
		 * @private
		 */
		override flash_proxy function callProperty( methodName:*, ... args:Array ):* {
			methodName;
			
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function getProperty( name:* ):* {
			if ( name in this ) { return this[name]; }
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function setProperty( name:*, value:* ):void {
		}
		
		/**
		 * @private
		 */
		override flash_proxy function deleteProperty( name:* ):Boolean {
			name;
			
			return false;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function hasProperty( name:* ):Boolean {
			name;
			
			return false;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextNameIndex( index:int ):int {
			index;
			
			return -1;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextName( index:int ):String {
			index;
			
			return null;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextValue( index:int ):* {
			index;
			
			return null;
		}
	}
}

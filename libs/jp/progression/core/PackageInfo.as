/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package jp.progression.core {
	import flash.display.Stage;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.utils.getDefinitionByName;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.StageUtil;
	import jp.nium.utils.StringUtil;
	
	/**
	 * @private
	 */
	public final class PackageInfo {
		
		/**
		 * <span lang="ja">アクティベートされているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get activated():Boolean { return _activated; }
		private static var _activated:Boolean = false;
		
		/**
		 * <span lang="ja">Progression クラスの参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get managerClassRef():Class {
			if ( _managerClassRef ) { return _managerClassRef; }
			
			try {
				_managerClassRef = getDefinitionByName( "jp.progression.Progression" ) as Class;
			}
			catch ( err:Error ) {}
			
			return _managerClassRef;
		}
		private static var _managerClassRef:Class;
		
		/**
		 * <span lang="ja">CastDocument クラスの参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get documentClassRef():Class {
			if ( _documentClassRef ) { return _documentClassRef; }
			
			try {
				_documentClassRef = getDefinitionByName( "jp.progression.casts.CastDocument" ) as Class;
			}
			catch ( err:Error ) {}
			
			return _documentClassRef;
		}
		private static var _documentClassRef:Class;
		
		/**
		 * <span lang="ja">プリローダーとして割り当てられたクラスの参照を取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get preloaderClassRef():Class {
			if ( _preloaderClassRef ) { return _preloaderClassRef; }
			
			try {
				_preloaderClassRef ||= getDefinitionByName( "jp.progression.casts.CastPreloader" ) as Class;
			}
			catch ( err:Error ) {}
			
			try {
				_preloaderClassRef ||= getDefinitionByName( "jp.progression.core.components.loader.PreloaderComp" ) as Class;
			}
			catch ( err:Error ) {}
			
			return _preloaderClassRef;
		}
		private static var _preloaderClassRef:Class;
		
		/**
		 * <span lang="ja">Debugger が実装されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get hasDebugger():Boolean {
			if ( _hasDebugger ) { return _hasDebugger; }
			
			try {
				_hasDebugger = Boolean( getDefinitionByName( "jp.progression.debug.Debugger" ) as Class );
			}
			catch ( err:Error ) {}
			
			return _hasDebugger;
		}
		private static var _hasDebugger:Boolean = false;
		
		/**
		 * <span lang="ja">Tweener が実装されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get hasTweener():Boolean {
			if ( _hasTweener ) { return _hasTweener; }
			
			try {
				_hasTweener = Boolean( getDefinitionByName( "caurina.transitions.Tweener" ) as Class );
			}
			catch ( err:Error ) {}
			
			return _hasTweener;
		}
		private static var _hasTweener:Boolean = false;
		
		/**
		 * <span lang="ja">SWFAddress が実装されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get hasSWFAddress():Boolean {
			if ( _hasSWFAddress ) { return _hasSWFAddress; }
			
			try {
				_hasSWFAddress = Boolean( getDefinitionByName( "com.asual.swfaddress.SWFAddress" ) as Class );
			}
			catch ( err:Error ) {}
			
			return _hasSWFAddress;
		}
		private static var _hasSWFAddress:Boolean = false;
		
		/**
		 * <span lang="ja">SWFSize が実装されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get hasSWFSize():Boolean {
			if ( _hasSWFSize ) { return _hasSWFSize; }
			
			try {
				_hasSWFSize = Boolean( getDefinitionByName( "org.libspark.ui.SWFSize" ) as Class );
			}
			catch ( err:Error ) {}
			
			return _hasSWFSize;
		}
		private static var _hasSWFSize:Boolean = false;
		
		/**
		 * <span lang="ja">SWFWheel が実装されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		public static function get hasSWFWheel():Boolean {
			if ( _hasSWFWheel ) { return _hasSWFWheel; }
			
			try {
				_hasSWFWheel = Boolean( getDefinitionByName( "org.libspark.ui.SWFWheel" ) as Class );
			}
			catch ( err:Error ) {}
			
			return _hasSWFWheel;
		}
		private static var _hasSWFWheel:Boolean = false;
		
		/**
		 * 
		 */
		private static var _connect:LocalConnection = new LocalConnection();
		
		
		
		
		
		/**
		 * @private
		 */
		public function PackageInfo() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function activate( stage:Stage ):void {
			if ( _activated ) { return; }
			
			try {
				var url:String = StringUtil.toProperType( ExternalInterface.call( "function() { return window.location.href; }" ) ) || StageUtil.getDocument( stage ).loaderInfo.url;
			}
			catch ( err:Error ) {}
			
			try {
				_connect.addEventListener( StatusEvent.STATUS, _status, false, 0, true );
				_connect.send( "application/progression-license-activation", "output", {
					version					:managerClassRef.VERSION,
					activatedLicenseType	:managerClassRef.config.activatedLicenseType,
					url						:url
				} );
			}
			catch ( err:Error ) {}
			
			_activated = true;
		}
		
		
		
		
		
		/**
		 * 
		 */
		private static function _status( e:StatusEvent ):void {
			_connect.removeEventListener( StatusEvent.STATUS, _status );
		}
	}		
}

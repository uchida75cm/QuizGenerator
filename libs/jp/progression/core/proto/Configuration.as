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
package jp.progression.core.proto {
	import flash.utils.getDefinitionByName;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.data.DataHolder;
	import jp.progression.executors.ExecutorObject;
	
	/**
	 * @private
	 */
	public class Configuration {
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the Configuration.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">適用されているライセンスの種類を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get activatedLicenseType():String { return _activatedLicenseType; }
		private var _activatedLicenseType:String;
		
		/**
		 * <span lang="ja">初期化処理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get initializer():Class { return _initializer; }
		private var _initializer:Class;
		
		/**
		 * <span lang="ja">シンクロナイザの実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get synchronizer():Class { return _synchronizer; }
		private var _synchronizer:Class;
		
		/**
		 * <span lang="ja">履歴管理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get historyManager():Class { return _historyManager; }
		private var _historyManager:Class;
		
		/**
		 * <span lang="ja">汎用的な処理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get executor():Class { return _executor || ExecutorObject; }
		private var _executor:Class;
		
		/**
		 * <span lang="ja">キーボード処理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get keyboardMapper():Class { return _keyboardMapper; }
		private var _keyboardMapper:Class;
		
		/**
		 * <span lang="ja">コンテクストメニュー処理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get contextMenuBuilder():Class { return _contextMenuBuilder; }
		private var _contextMenuBuilder:Class;
		
		/**
		 * <span lang="ja">ツールチップ処理の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get toolTipRenderer():Class { return _toolTipRenderer; }
		private var _toolTipRenderer:Class;
		
		/**
		 * <span lang="ja">データ管理機能の実装として使用したいクラスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get dataHolder():Class { return _dataHolder || DataHolder; }
		private var _dataHolder:Class;
		
		/**
		 * 
		 */
		private var _defaultActivatedLicenseType:String = "PLL Basic";
		
		/**
		 * ActivatedLicenseType を更新したことがあるかどうかを取得します。
		 */
		private var _activatedLicenseTypeUpdated:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Configuration インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Configuration object.</span>
		 * 
		 * @param activatedLicenseType
		 * <span lang="ja">適用させたいライセンスの種類です。</span>
		 * <span lang="en"></span>
		 * @param initializer
		 * <span lang="ja">イニシャライザの実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param synchronizer
		 * <span lang="ja">シンクロナイザの実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param historyManager
		 * <span lang="ja">履歴管理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param executor
		 * <span lang="ja">汎用的な処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param keyboardMapper
		 * <span lang="ja">キーボード処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param contextMenuBuilder
		 * <span lang="ja">コンテクストメニュー処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param toolTipRenderer
		 * <span lang="ja">ツールチップ処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param dataHolder
		 * <span lang="ja">データ管理機能の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 */
		public function Configuration( activatedLicenseType:String = null, initializer:Class = null, synchronizer:Class = null, historyManager:Class = null, executor:Class = null, keyboardMapper:Class = null, contextMenuBuilder:Class = null, toolTipRenderer:Class = null, dataHolder:Class = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			progression_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 親クラスを初期化する
			super();
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == Configuration ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( _classNameObj.toString() ) ); }
			
			// ライセンスを適用する
			_activatedLicenseType = activatedLicenseType || _defaultActivatedLicenseType;
			
			// 引数を設定する
			_initializer = initializer;
			_synchronizer = synchronizer;
			_historyManager = historyManager;
			_executor = executor;
			_keyboardMapper = keyboardMapper;
			_contextMenuBuilder = contextMenuBuilder;
			_toolTipRenderer = toolTipRenderer;
			_dataHolder = dataHolder;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal function $updateActivatedLicenseType():void {
			if ( _activatedLicenseTypeUpdated ) { return; }
			
			try {
				var cls:Class = getDefinitionByName( "jp.progression.core.components.config.ConfigComp" ) as Class;
				
				// ライセンスを適用する
				_activatedLicenseType = cls.progression_internal::$activatedLicenseType || _defaultActivatedLicenseType;
				
				_activatedLicenseTypeUpdated = true;
			}
			catch ( err:Error ) {}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString():String {
			return ObjectUtil.formatToString( this, _classNameObj.toString(), "activatedLicenseType" );
		}
	}
}

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
package jp.progression.scenes {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StringUtil;
	import jp.progression.commands.display.AddChild;
	import jp.progression.commands.display.AddChildAt;
	import jp.progression.commands.display.RemoveChild;
	import jp.progression.commands.lists.ParallelList;
	import jp.progression.core.display.EasyCastingContainer;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.events.DataProvideEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.executors.CommandExecutor;
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">EasyCastingScene クラスは、拡張された PRML 形式の XML データを使用して ActionScript を使用しないコンポーネントベースの開発スタイルを提供するクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // EasyCastingScene インスタンスを作成する
	 * var scene:EasyCastingScene = new EasyCastingScene();
	 * </listing>
	 */
	public class EasyCastingScene extends SceneObject {
		
		/**
		 * すべてのインスタンスを保持した Dictionary インスタンスを取得します。
		 */
		private static var _instances:Dictionary = new Dictionary();
		
		/**
		 * 現在表示しているインスタンスを保持した Dictionary インスタンスを取得します。
		 */
		private static var _displayingList:Dictionary = new Dictionary();
		
		/**
		 * コンテナインスタンスを保持した Dictionary インスタンスを取得します。
		 */
		private static var _containers:Dictionary = new Dictionary();
		
		
		
		
		
		/**
		 * <span lang="ja">自身に移動した際に表示させる表示オブジェクトを保持した配列を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get casts():Array { return _casts.slice(); }
		private var _casts:Array;
		
		/**
		 * キャストオブジェクトのクラス名をキーとして、パラメータを保持した Dictionary インスタンスを取得します。
		 */
		private var _castParameters:Dictionary;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい EasyCastingScene インスタンスを作成します。</span>
		 * <span lang="en">Creates a new EasyCastingScene object.</span>
		 * 
		 * @param name
		 * <span lang="ja">シーンの名前です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function EasyCastingScene( name:String = null, initObject:Object = null ) {
			// 初期化する
			_casts = [];
			_castParameters = new Dictionary();
			
			// 親クラスを初期化する
			super( name, initObject );
			
			// Progression が CommandExecutor を実装していなければ例外をスローする
			if ( Progression.config.executor != CommandExecutor ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_017 ).toString( className, "CommandExecutor" ) ); }
			
			// イベントリスナーを登録する
			super.addEventListener( SceneEvent.SCENE_UNLOAD, _sceneUnload, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_INIT, _sceneInit, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_ADDED_TO_ROOT, _sceneAddedToRoot, false, 0, true );
			super.addEventListener( SceneEvent.SCENE_REMOVED_FROM_ROOT, _sceneRemovedFromRoot, false, 0, true );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">XML データが EasyCasting 拡張 PRML フォーマットに準拠しているかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="ja">フォーマットを検査したい XML データです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">フォーマットが合致すれば true を、合致しなければ false となります。</span>
		 * <span lang="en"></span>
		 * 
		 * @example <listing version="3.0">
		 * </listing>
		 */
		public static function validate( prml:XML ):Boolean {
			prml = new XML( prml.toXMLString() );
			
			// コンテンツタイプを確認する
			switch ( String( prml.attribute( "type" ) ) ) {
				case "text/easycasting"			:
				case "text/prml.easycasting"	: { break; }
				default							: { return false; }
			}
			
			// 必須プロパティを精査する
			for each ( var cast:XML in prml..cast ) {
				if ( !String( cast.attribute( "cls" ) ) ) { return false; }
			}
			
			// PRML として評価する
			prml.@type = "text/prml.plain";
			
			return SceneObject.validate( prml );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">この SceneObject インスタンスの子を PRML 形式の XML データから追加します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="en">PRML 形式の XML データです。</span>
		 * <span lang="en"></span>
		 */
		override public function addSceneFromXML( prml:XML ):void {
			// <scene> の cls を上書きする
			for each ( var scene:XML in prml..scene ) {
				scene.@cls = "jp.progression.scenes.EasyCastingScene";
			}
			
			// PRML のフォーマットが正しくなければ例外をスローする
			if ( !validate( prml ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( "PRML" ) ); }
			
			// 親のメソッドを実行する
			super.addSceneFromXML( prml );
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			_casts = [];
			_castParameters = new Dictionary();
			
			// 親のメソッドを実行する
			super.dispose();
		}
		
		
		
		
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 */
		private function _sceneUnload( e:SceneEvent ):void {
			// 対象がルートでなければ終了する
			if ( this != super.root ) { return; }
			
			// コンテナを取得する
			_containers[super.container] ||= new EasyCastingContainer( this );
			var container:EasyCastingContainer = _containers[super.container];
			
			// コマンドリストを作成する
			var removeChildList:ParallelList = new ParallelList();
			
			// すでに表示されている対象を検索する
			for ( var cls:String in _displayingList ) {
				// コマンドを追加する
				removeChildList.addCommand( new RemoveChild( container, _displayingList[cls] ) );
				
				// 登録から削除する
				delete _displayingList[cls];
			}
			
			// コマンドを追加する
			super.addCommand( removeChildList );
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 */
		private function _sceneInit( e:SceneEvent ):void {
			// コンテナを取得する
			_containers[super.container] ||= new EasyCastingContainer( this );
			var container:EasyCastingContainer = _containers[super.container];
			
			// コンテナが登録されていなければ登録する
			if ( !super.container.contains( container ) ) {
				super.container.addChild( container );
			}
			
			// コマンドリストを作成する
			var addChildList:ParallelList = new ParallelList();
			var removeChildList:ParallelList = new ParallelList();
			
			// すでに表示されている対象を検索する
			for ( var cls:String in _displayingList ) {
				// 登録されていれば次へ
				if ( _castParameters[cls] ) { continue; }
				
				// コマンドを追加する
				removeChildList.addCommand( new RemoveChild( container, _displayingList[cls] ) );
				
				// 登録から削除する
				delete _displayingList[cls];
			}
			
			// 現在のシーンで必要な対象を追加する
			for ( var cast:String in _castParameters ) {
				// インスタンスを取得する
				var instance:Sprite = _displayingList[cast];
				
				// すでに表示されていれば次へ
				if ( instance ) { continue; }
				
				// インスタンスを取得する
				instance = _instances[cast];
				
				// プロパティを設定する
				ObjectUtil.setProperties( instance, _castParameters[cast] );
				
				// インデックスを取得する
				var index:String = _castParameters[cast].index;
				
				// コマンドを追加する
				if ( index ) {
					addChildList.addCommand( new AddChildAt( container, instance, parseInt( index ) ) );
				}
				else {
					addChildList.addCommand( new AddChild( container, instance ) );
				}
				
				// 表示中リストに登録する
				_displayingList[cast] = instance;
			}
			
			// コマンドを追加する
			super.addCommand( removeChildList, addChildList );
		}
		
		/**
		 * シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの追加により、ルートシーン上のシーンリストに追加されたときに送出されます。
		 */
		private function _sceneAddedToRoot( e:SceneEvent ):void {
			if ( super.dataHolder ) {
				super.dataHolder.addEventListener( DataProvideEvent.DATA_UPDATE, _update, false, 0, true );
			}
		}
		
		/**
		 * シーンオブジェクトが直接、またはシーンオブジェクトを含むサブツリーの削除により、ルートシーン上のシーンリストから削除されようとしているときに送出されます。
		 */
		private function _sceneRemovedFromRoot( e:SceneEvent ):void {
			if ( super.dataHolder ) {
				super.dataHolder.removeEventListener( DataProvideEvent.DATA_UPDATE, _update );
			}
		}
		
		/**
		 * 管理するデータが更新された場合に送出されます。
		 */
		private function _update( e:DataProvideEvent ):void {
			// データを取得する
			var xml:XML = new XML( super.toXMLString() );
			
			// cast を取得する
			_castParameters = new Dictionary();
			for each ( var cast:XML in xml.cast ) {
				var o:Object = {};
				
				// アトリビュートを取得する
				for each ( var attribute:XML in cast.attributes() ) {
					o[String( attribute.name() )] = StringUtil.toProperType( attribute );
				}
				
				_castParameters[String( cast.@cls )] = o;
			}
			
			// インスタンスを作成する
			_casts = [];
			for ( var clsPath:String in _castParameters ) {
				try {
					// クラスの参照を取得する
					var cls:Class = getDefinitionByName( clsPath ) as Class;
					
					// インスタンスを生成する
					_instances[clsPath] ||= new cls();
					
					// リストに追加する
					_casts.push( clsPath );
				}
				catch ( err:Error ) {
					// 警告を表示する
					Logger.error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_018 ).toString( clsPath ) );
					
					// 登録を破棄する
					delete _castParameters[clsPath];
				}
			}
		}
	}
}

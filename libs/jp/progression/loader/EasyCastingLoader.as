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
package jp.progression.loader {
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.Progression;
	import jp.progression.scenes.EasyCastingScene;
	
	/**
	 * <span lang="ja">EasyCastingLoader クラスは、読み込んだ拡張された PRML 形式の XML ファイルから自動的に、Progression インスタンスを作成するローダークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // EasyCastingLoader インスタンスを作成する
	 * var loader:EasyCastingLoader = new EasyCastingLoader();
	 * </listing>
	 */
	public class EasyCastingLoader extends PRMLLoader {
		
		
		
		
		
		/**
		 * <span lang="ja">新しい EasyCastingLoader インスタンスを作成します。</span>
		 * <span lang="en">Creates a new EasyCastingLoader object.</span>
		 * 
		 * @param container
		 * <span lang="ja">関連付けたい DisplayObjectContainer インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param request
		 * <span lang="ja">ダウンロードする URL を指定する URLRequest オブジェクトです。このパラメータを省略すると、ロード操作は開始されません。指定すると、直ちにロード操作が開始されます。詳細については、load を参照してください。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function EasyCastingLoader( container:DisplayObjectContainer, request:URLRequest = null, initObject:Object = null ) {
			// クラスをコンパイルに含める
			EasyCastingScene;
			
			// 親クラスを初期化する
			super( container, request, initObject );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">XML データから Progression インスタンスを作成します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param prml
		 * <span lang="ja">生成に使用する XML データです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">生成された Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		override public function parse( prml:XML ):Progression {
			// cls 属性の値を全て上書きする
			for each ( var scene:XML in prml..scene ) {
				scene.@cls = "jp.progression.scenes.EasyCastingScene";
			}
			
			// XML の構文が間違っていれば例外をスローする
			if ( !EasyCastingScene.validate( prml ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_016 ).toString( "XML" ) ); }
			
			// 親のメソッドを実行する
			return super.parse( prml );
		}
	}
}

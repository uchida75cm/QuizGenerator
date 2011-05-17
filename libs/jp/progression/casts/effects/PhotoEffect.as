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
package jp.progression.casts.effects {
	import fl.transitions.Photo;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.core.display.EffectBase;
	
	/**
	 * <span lang="ja">写真のフラッシュのようにムービークリップオブジェクトの表示 / 非表示を切り替えます。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en">Makes the movie clip object appear or disappear like a photographic flash.
	 * </span>
	 * 
	 * @example <listing version="3.0">
	 * // PhotoEffect インスタンスを作成する
	 * var cast:PhotoEffect = new PhotoEffect();
	 * cast.graphics.beginFill( 0x000000 );
	 * cast.graphics.drawRect( 0, 0, 100, 100 );
	 * cast.graphics.endFill();
	 * 
	 * // エフェクト毎の設定を行う
	 * cast.dimension = EffectDirectionType.IN;
	 * cast.duration = 3;
	 * cast.easing = Cubic.easeInOut;
	 * 
	 * // SerialList コマンドを実行する
	 * new SerialList( null,
	 * 	// 画面に表示する
	 * 	new AddChild( this, cast ),
	 * 	
	 * 	// 画面から消去する
	 * 	new RemoveChild( this, cast )
	 * ).execute();
	 * </listing>
	 */
	public class PhotoEffect extends EffectBase {
		
		/**
		 * @private
		 */
		override public function get parameters():Object { return {}; }
		override public function set parameters( value:Object ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "parameters" ) ); }
		
		
		
		
		/**
		 * <span lang="ja">新しい PhotoEffect インスタンスを作成します。</span>
		 * <span lang="en">Creates a new PhotoEffect object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function PhotoEffect( initObject:Object = null ) {
			// 親クラスを初期化する
			super( Photo, initObject );
		}
	}
}

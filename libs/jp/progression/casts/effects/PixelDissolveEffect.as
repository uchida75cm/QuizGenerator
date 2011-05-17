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
	import fl.transitions.PixelDissolve;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.display.EffectBase;
	
	/**
	 * <span lang="ja">PixelDissolveEffect クラスは、チェッカーボードのパターンでランダムに表示される矩形または消える矩形を使用して、ムービークリップオブジェクトを表示します。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en">The PixelDissolveEffect class reveals reveals the movie clip object by using randomly appearing or disappearing rectangles in a checkerboard pattern.
	 * </span>
	 * 
	 * @example <listing version="3.0">
	 * // PixelDissolveEffect インスタンスを作成する
	 * var cast:PixelDissolveEffect = new PixelDissolveEffect();
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
	public class PixelDissolveEffect extends EffectBase {
		
		/**
		 * <span lang="ja">水平軸に沿ったマスク矩形セクションの数を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get xSections():int { return super.parameters.xSections; }
		public function set xSections( value:int ):void { super.parameters.xSections = value; }
		
		/**
		 * <span lang="ja">垂直軸に沿ったマスク矩形セクションの数を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get ySections():int { return super.parameters.ySections; }
		public function set ySections( value:int ):void { super.parameters.ySections = value; }
		
		/**
		 * @private
		 */
		override public function get parameters():Object { return {}; }
		override public function set parameters( value:Object ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "parameters" ) ); }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい PixelDissolveEffect インスタンスを作成します。</span>
		 * <span lang="en">Creates a new PixelDissolveEffect object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function PixelDissolveEffect( initObject:Object = null ) {
			// 親クラスを初期化する
			super( PixelDissolve, initObject );
			
			// 初期化する
			super.parameters.xSections = 10;
			super.parameters.ySections = 10;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "direction", "duration", "xSections", "ySections" );
		}
	}
}

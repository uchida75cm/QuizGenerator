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
	import fl.transitions.Wipe;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.display.EffectBase;
	
	/**
	 * <span lang="ja">WipeEffect クラスは、水平方向に移動するシェイプのアニメーション化されたマスクを使用して、ムービークリップオブジェクトの表示と非表示を切り替えます。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en">The WipeEffect class reveals or hides the movie clip object by using an animated mask of a shape that moves horizontally.
	 * </span>
	 * 
	 * @example <listing version="3.0">
	 * // WipeEffect インスタンスを作成する
	 * var cast:WipeEffect = new WipeEffect();
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
	public class WipeEffect extends EffectBase {
		
		/**
		 * <span lang="ja">エフェクトの開始位置を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get startPoint():int { return super.parameters.startPoint; }
		public function set startPoint( value:int ):void { super.parameters.startPoint = value; }
		
		/**
		 * @private
		 */
		override public function get parameters():Object { return {}; }
		override public function set parameters( value:Object ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "parameters" ) ); }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WipeEffect インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WipeEffect object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function WipeEffect( initObject:Object = null ) {
			// 親クラスを初期化する
			super( Wipe, initObject );
			
			// 初期化する
			super.parameters.startPoint = 5;
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "direction", "duration", "startPoint" );
		}
	}
}

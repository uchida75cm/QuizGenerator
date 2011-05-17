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
package jp.progression.casts.animation {
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.progression.commands.tweens.DoTweenFrame;
	import jp.progression.core.display.AnimationBase;
	import jp.progression.events.CastEvent;
	
	/**
	 * <span lang="ja">InOutMovie クラスは、表示リストへの追加・削除の状態に応じたタイムラインアニメーションを実行するためのコンポーネントクラスです。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class InOutMovie extends AnimationBase {
		
		/**
		 * <span lang="ja">新しい InOutMovie インスタンスを作成します。</span>
		 * <span lang="en">Creates a new InOutMovie object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function InOutMovie( initObject:Object = null ) {
			// 親クラスを初期化する
			super( initObject );
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, 0, true );
			super.addEventListener( CastEvent.CAST_ADDED, _castAdded, false, 0, true );
			super.addEventListener( CastEvent.CAST_REMOVED, _castRemoved, false, 0, true );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _addedToStage( e:Event ):void {
			// 対象を取得する
			var target:MovieClip = super.component ? super.component.target || this : this;
			target.visible = false;
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 */
		private function _castAdded( e:CastEvent ):void {
			// 対象を取得する
			var target:MovieClip = super.component ? super.component.target || this : this;
			
			super.addCommand(
				function():void {
					target.visible = true;
				},
				new DoTweenFrame( target, "in", "stop" )
			);
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 */
		private function _castRemoved( e:CastEvent ):void {
			// 対象を取得する
			var target:MovieClip = super.component ? super.component.target || this : this;
			
			super.addCommand(
				new DoTweenFrame( target, "stop", "out" ),
				function():void {
					target.visible = false;
				}
			);
		}
	}
}

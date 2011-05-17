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
package jp.progression.core.display {
	import fl.transitions.easing.None;
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.casts.CastMovieClip;
	import jp.progression.commands.tweens.DoTransition;
	import jp.progression.core.components.effects.IEffectComp;
	import jp.progression.events.CastEvent;
	
	/**
	 * <span lang="ja">EffectBase クラスは、エフェクトコンポーネントとして動作させるために必要な機能を実装した表示オブジェクトクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class EffectBase extends CastMovieClip {
		
		/**
		 * <span lang="ja">コンポーネントの実装として使用される場合の対象コンポーネントを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get component():IEffectComp { return _component; }
		private var _component:IEffectComp;
		
		/**
		 * <span lang="ja">対象に適用するトランジション効果のクラスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see fl.transitions
		 */
		protected function get type():Class { return _type; }
		private var _type:Class;
		
		/**
		 * <span lang="ja">イージングの適用方向を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.casts.effects.EffectDirectionType
		 */
		public function get direction():String { return _direction; }
		public function set direction( value:String ):void {
			switch ( value ) {
				case "in"		:
				case "inOut"	:
				case "out"		: { _direction = value; break; }
				default			: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_003 ).toString( "direction" ) ); }
			}
		}
		private var _direction:String = "inOut";
		
		/**
		 * <span lang="ja">アニメーションの継続時間を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get duration():Number { return _duration; }
		public function set duration( value:Number ):void { _duration = value; }
		private var _duration:Number = 1.0;
		
		/**
		 * <span lang="ja">アニメーションのトゥイーン効果を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see fl.motion.easing
		 * @see fl.transitions.easing
		 */
		public function get easing():Function { return _easing; }
		public function set easing( value:Function ):void { _easing = value; }
		private var _easing:Function;
		
		/**
		 * <span lang="ja">カスタムトゥイーンパラメータを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get parameters():Object { return _parameters; }
		public function set parameters( value:Object ):void { _parameters = value; }
		private var _parameters:Object;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい EffectBase インスタンスを作成します。</span>
		 * <span lang="en">Creates a new EffectBase object.</span>
		 * 
		 * @param type
		 * <span lang="ja">適用するトランジション効果のクラスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function EffectBase( type:Class, initObject:Object = null ) {
			// 引数を設定する
			_type = type;
			_component = initObject as IEffectComp;
			
			// 初期化する
			_parameters = {};
			
			// 親クラスを初期化する
			super( initObject );
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == EffectBase ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _addedToStage, false, 0, true );
			super.addEventListener( CastEvent.CAST_ADDED, _castAdded, false, 0, true );
			super.addEventListener( CastEvent.CAST_REMOVED, _castRemoved, false, 0, true );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "direction", "duration" );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _addedToStage( e:Event ):void {
			// 対象を取得する
			var target:MovieClip = _component ? _component.target || this : this;
			
			switch ( _direction ) {
				case "in"		:
				case "inOut"	: { target.visible = false; break; }
				case "out"		: { break; }
			}
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 */
		private function _castAdded( e:CastEvent ):void {
			// 対象を取得する
			var target:MovieClip = _component ? _component.target || this : this;
			
			switch ( _direction ) {
				case "in"		:
				case "inOut"	: {
					super.addCommand(
						function():void {
							target.visible = true;
						},
						new DoTransition( target, _type, 0, _duration, _easing || None.easeNone, _parameters )
					);
					break;
				}
				case "out"		: { break; }
			}
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 */
		private function _castRemoved( e:CastEvent ):void {
			// 対象を取得する
			var target:MovieClip = _component ? _component.target || this : this;
			
			switch ( _direction ) {
				case "in"		: { break; }
				case "inOut"	:
				case "out"		: {
					super.addCommand(
						new DoTransition( target, _type, 1, _duration, _easing || None.easeNone, _parameters ),
						function():void {
							target.visible = false;
						}
					);
					break;
				}
			}
		}
	}
}

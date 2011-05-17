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
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.casts.CastButton;
	import jp.progression.commands.CommandInterruptType;
	import jp.progression.commands.tweens.DoTweenFrame;
	import jp.progression.core.components.buttons.IButtonComp;
	import jp.progression.core.events.ComponentEvent;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.events.CastMouseEvent;
	
	/**
	 * <span lang="ja">ButtonBase クラスは、ボタンコンポーネントとして動作させるために必要な機能を実装した表示オブジェクトクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class ButtonBase extends CastButton {
		
		/**
		 * <span lang="ja">アクションを UP 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const ACTION_UP:String = "up";
		
		/**
		 * <span lang="ja">アクションを OVER 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const ACTION_OVER:String = "over";
		
		/**
		 * <span lang="ja">アクションを DOWN 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const ACTION_DOWN:String = "down";
		
		/**
		 * <span lang="ja">ステートを NEUTRAL 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const STATE_NEUTRAL:String = "neutral";
		
		/**
		 * <span lang="ja">ステートを CURRENT 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const STATE_CURRENT:String = "current";
		
		/**
		 * <span lang="ja">ステートを CONTAIN 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const STATE_CONTAIN:String = "contain";
		
		/**
		 * <span lang="ja">ステートを DISABLE 状態に指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const STATE_DISABLE:String = "disable";
		
		
		
		
		
		/**
		 * <span lang="ja">コンポーネントの実装として使用される場合の対象コンポーネントを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get component():IButtonComp { return _component; }
		private var _component:IButtonComp;
		
		/**
		 * <span lang="ja">移動する際、すでに移動プロセスが実行中である場合に、既存のプロセスを中断するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get enforce():Boolean { return _enforce; }
		public function set enforce( value:Boolean ):void { _enforce = value; }
		private var _enforce:Boolean = false;
		
		/**
		 * <span lang="ja">このスプライトのボタンモードを指定します。</span>
		 * <span lang="en">Specifies the button mode of this sprite.</span>
		 */
		override public function get buttonMode():Boolean { return super.buttonMode; }
		override public function set buttonMode( value:Boolean ):void {
			var oldValue:Boolean = super.buttonMode;
			
			super.buttonMode = value;
			
			if ( oldValue != value ) {
				_castStateChange( null );
			}
		}
		
		/**
		 * ターゲットとなるインスタンスを取得します。
		 */
		private function get _target():MovieClip { return _component ? _component.target || this : this; }
		
		/**
		 * ボタン状態に対応したフレーム番号を取得します。
		 */
		private var _frames:Object;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ButtonBase インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ButtonBase object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ButtonBase( initObject:Object = null ) {
			// 引数を設定する
			_component = initObject as IButtonComp;
			
			// 親クラスを初期化する
			super( initObject );
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == ButtonBase ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			// 再生を停止する
			super.gotoAndStop( 1 );
			
			// フレームラベルを初期化する
			_initialize( this );
			
			// イベントリスナーを登録する
			super.addEventListener( Event.ADDED_TO_STAGE, _event, false, 0, true );
			super.addEventListener( Event.REMOVED_FROM_STAGE, _event, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_MOUSE_DOWN, _castMouseDown, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE, _castMouseDown, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_MOUSE_UP, _castMouseUp, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_MOUSE_UP_COMPLETE, _castMouseUp, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_ROLL_OVER, _castRollOver, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_ROLL_OVER_COMPLETE, _castRollOver, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_ROLL_OUT, _castRollOut, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_ROLL_OUT_COMPLETE, _castRollOut, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_STATE_CHANGE, _castStateChange, false, 0, true );
			super.addEventListener( CastMouseEvent.CAST_NAVIGATE_BEFORE, _castNavigateBefore, false, 0, true );
			
			// コンポーネントが実装されていれば
			if ( _component ) {
				super.addEventListener( MouseEvent.MOUSE_DOWN, _delegateMouseEvent, false, 0, true );
				super.addEventListener( MouseEvent.MOUSE_UP, _delegateMouseEvent, false, 0, true );
				super.addEventListener( MouseEvent.ROLL_OVER, _delegateMouseEvent, false, 0, true );
				super.addEventListener( MouseEvent.ROLL_OUT, _delegateMouseEvent, false, 0, true );
				_component.addEventListener( ComponentEvent.COMPONENT_ADDED, _componentAdded, false, 0, true );
				_component.addEventListener( ComponentEvent.COMPONENT_REMOVED, _componentRemoved, false, 0, true );
			}
		}
		
		
		
		
		/**
		 * ボタンを初期化します。
		 */
		private function _initialize( target:MovieClip ):void {
			_frames = {
				neutral		:{ up:undefined, over:undefined, down:undefined },
				current		:{ up:undefined, over:undefined, down:undefined },
				contain		:{ up:undefined, over:undefined, down:undefined },
				disable		:{ up:undefined, over:undefined, down:undefined }
			};
			
			// 設定されているフレームラベルを取得する
			var scenes:Array = target.scenes;
			for ( var i:int = 0, l:int = scenes.length; i < l; i++ ) {
				var labels:Array = scenes[i].labels;
				
				for ( var ii:int = 0, ll:int = labels.length; ii < ll; ii++ ) {
					var label:FrameLabel = FrameLabel( labels[ii] );
					
					var result:Array = new RegExp( "(| |,)(" + STATE_NEUTRAL + "|" + STATE_CURRENT + "|" + STATE_CONTAIN + "|" + STATE_DISABLE + ")(| |,)", "gi" ).exec( label.name ) || [];
					var state:String = result[2] || STATE_NEUTRAL;
					
					result = new RegExp( "(| |,)(" + ACTION_UP + "|" + ACTION_OVER + "|" + ACTION_DOWN + ")(| |,)", "gi" ).exec( label.name ) || [];
					var action:String = result[2] || ACTION_UP;
					
					_frames[state][action] = label.frame;
				}
			}
			
			// 設定されていない項目を補完する
			_frames.neutral.up ||= 1;
			_frames.neutral.over ||= _frames.neutral.up;
			_frames.neutral.down ||= _frames.neutral.up;
			
			_frames.current.over ||= _frames.current.up || _frames.neutral.over;
			_frames.current.down ||= _frames.current.up || _frames.neutral.down;
			_frames.current.up ||= _frames.neutral.up;
			
			_frames.contain.over ||= _frames.contain.up || _frames.neutral.over;
			_frames.contain.down ||= _frames.contain.up || _frames.neutral.down;
			_frames.contain.up ||= _frames.neutral.up;
			
			_frames.disable.over ||= _frames.disable.up || _frames.neutral.over;
			_frames.disable.down ||= _frames.disable.up || _frames.neutral.down;
			_frames.disable.up ||= _frames.neutral.up;
			
			// 初期化する
			_castStateChange( null );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _event( e:Event ):void {
			var frame:*;
			
			switch ( super.state ) {
				case 0	: { frame = _frames.disable[ACTION_UP]; break; }
				case 1	: { frame = _frames.contain[ACTION_UP]; break; }
				case 2	: { frame = _frames.current[ACTION_UP]; break; }
				case 3	:
				case 4	:
				default	: { frame = _frames.neutral[ACTION_UP]; }
			}
			
			_target.gotoAndStop( frame );
		}
		
		/**
		 * マウスに関連するイベントを委譲します。
		 */
		private function _delegateMouseEvent( e:MouseEvent ):void {
			// 後続するノードでイベントリスナーが処理されないようにする
			e.stopPropagation();
		}
		
		/**
		 * コンポーネントが有効化された状態で、表示オブジェクトが、直接、または表示オブジェクトを含むサブツリーの追加により、ステージ上の表示リストに追加されたときに送出されます。
		 */
		private function _componentAdded( e:ComponentEvent ):void {
			// フレームラベルを初期化する
			_initialize( _component.target || this );
		}
		
		/**
		 * コンポーネントが表示ツリーから削除された場合に送出されます。
		 */
		private function _componentRemoved( e:ComponentEvent ):void {
			// フレームラベルを初期化する
			_initialize( this );
		}
		
		/**
		 * Flash Player ウィンドウの CastButton インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 */
		private function _castMouseDown( e:CastMouseEvent ):void {
			var frame:*;
			
			// アクションを取得する
			var action:String = ACTION_DOWN;
			
			switch ( super.state ) {
				case 0	: { frame = _frames.disable[action]; break; }
				case 1	: { frame = _frames.contain[action]; break; }
				case 2	: { frame = _frames.current[action]; break; }
				case 3	:
				case 4	:
				default	: { frame = _frames.neutral[action]; }
			}
			
			switch ( e.type ) {
				case CastMouseEvent.CAST_MOUSE_DOWN				: {
					super.addCommand(
						new DoTweenFrame( _target, _target.currentFrame, frame, {
							interruptType	:CommandInterruptType.SKIP,
							onComplete		:function():void { _castStateChange( e ); },
							onInterrupt		:function():void { _castStateChange( e ); }
						} )
					);
					break;
				}
				case CastMouseEvent.CAST_MOUSE_DOWN_COMPLETE	: { _castStateChange( e ); break; }
			}
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _castMouseUp( e:CastMouseEvent ):void {
			var frame:*;
			
			// アクションを取得する
			var action:String = super.isRollOver ? ACTION_OVER : ACTION_UP;
			
			switch ( super.state ) {
				case 0	: { frame = _frames.disable[action]; break; }
				case 1	: { frame = _frames.contain[action]; break; }
				case 2	: { frame = _frames.current[action]; break; }
				case 3	:
				case 4	:
				default	: { frame = _frames.neutral[action]; }
			}
			
			switch ( e.type ) {
				case CastMouseEvent.CAST_MOUSE_UP				: {
					super.addCommand(
						new DoTweenFrame( _target, _target.currentFrame, frame, {
							interruptType	:CommandInterruptType.SKIP,
							onComplete		:function():void { _castStateChange( e ); },
							onInterrupt		:function():void { _castStateChange( e ); }
						} )
					);
					break;
				}
				case CastMouseEvent.CAST_MOUSE_UP_COMPLETE		: { _castStateChange( e ); break; }
			}
		}
		
		/**
		 * ユーザーが CastButton インスタンスにポインティングデバイスを合わせたときに送出されます。
		 */
		private function _castRollOver( e:CastMouseEvent ):void {
			var frame:*;
			
			// アクションを取得する
			var action:String = ACTION_OVER;
			
			switch ( super.state ) {
				case 0	: { frame = _frames.disable[action]; break; }
				case 1	: { frame = _frames.contain[action]; break; }
				case 2	: { frame = _frames.current[action]; break; }
				case 3	:
				case 4	:
				default	: { frame = _frames.neutral[action]; }
			}
			
			switch ( e.type ) {
				case CastMouseEvent.CAST_ROLL_OVER				: {
					super.addCommand(
						new DoTweenFrame( _target, _target.currentFrame, frame, {
							interruptType	:CommandInterruptType.SKIP,
							onComplete		:function():void { _castStateChange( e ); },
							onInterrupt		:function():void { _castStateChange( e ); }
						} )
					);
					break;
				}
				case CastMouseEvent.CAST_ROLL_OVER_COMPLETE		: { _castStateChange( e ); break; }
			}
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _castRollOut( e:CastMouseEvent ):void {
			var frame:*;
			
			// アクションを取得する
			var action:String = super.isMouseDown ? ACTION_DOWN : ACTION_UP;
			
			switch ( super.state ) {
				case 0	: { frame = _frames.disable[action]; break; }
				case 1	: { frame = _frames.contain[action]; break; }
				case 2	: { frame = _frames.current[action]; break; }
				case 3	:
				case 4	:
				default	: { frame = _frames.neutral[action]; }
			}
			
			switch ( e.type ) {
				case CastMouseEvent.CAST_ROLL_OUT				: {
					super.addCommand(
						new DoTweenFrame( _target, _target.currentFrame, frame, {
							interruptType	:CommandInterruptType.SKIP,
							onComplete		:function():void { _castStateChange( e ); },
							onInterrupt		:function():void { _castStateChange( e ); }
						} )
					);
					break;
				}
				case CastMouseEvent.CAST_ROLL_OUT_COMPLETE		: { _castStateChange( e ); break; }
			}
		}
		
		/**
		 * ボタンの状態が変更された場合に送出されます。
		 */
		private function _castStateChange( e:CastMouseEvent ):void {
			// アクションを取得する
			var action:String = super.isRollOver ? ACTION_OVER : ACTION_UP;
			
			// マウスイベントが存在しなければ
			if ( !e ) {
				action = ACTION_UP;
			}
			
			// 表示を更新する
			switch ( super.state ) {
				case 0	: { _target.gotoAndStop( _frames.disable[action] ); break; }
				case 1	: { _target.gotoAndStop( _frames.contain[action] ); break; }
				case 2	: { _target.gotoAndStop( _frames.current[action] ); break; }
				case 3	:
				case 4	:
				default	: { _target.gotoAndStop( _frames.neutral[action] ); }
			}
		}
		
		/**
		 * ボタンが移動処理を開始する直前に送出されます。
		 */
		private function _castNavigateBefore( e:CastMouseEvent ):void {
			// 移動先が href プロパティに指定されていたら終了する
			if ( super.href ) { return; }
			
			// 存在しなければ終了する
			if ( !super.manager ) {
				Logger.error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_013 ).toString( super.sceneId ) );
				return;
			}
			
			// 実行中であれば中断する
			if ( _enforce && super.manager.state > 0 ) {
				super.manager.stop();
			}
		}
	}
}

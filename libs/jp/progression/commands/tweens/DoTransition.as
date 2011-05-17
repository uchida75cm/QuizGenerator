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
package jp.progression.commands.tweens {
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">コマンド処理中に状態が更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_UPDATE
	 */
	[Event( name="executeUpdate", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">DoTransition クラスは、fl.transitions パッケージのトランジション機能を実行するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DoTransition インスタンスを作成する
	 * var com:DoTransition = new DoTransition();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoTransition extends Command {
		
		/**
		 * <span lang="ja">トランジション効果を適用する対象の MovieClip オブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get target():MovieClip { return _target; }
		public function set target( value:MovieClip ):void { _target = value; }
		private var _target:MovieClip;
		
		/**
		 * <span lang="ja">Tween インスタンスに適用する Transition を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get type():Class { return _type; }
		public function set type( value:Class ):void { _type= value; }
		private var _type:Class;
		
		/**
		 * <span lang="ja">Tween インスタンスのイージングの方向を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get direction():int { return _direction; }
		public function set direction( value:int ):void {
			switch ( _direction ) {
				case Transition.IN		:
				case Transition.OUT		: { _direction = value; break; }
				default					: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_003 ).toString( "direction" ) ); }
			}
		}
		private var _direction:int = Transition.IN;
		
		/**
		 * <span lang="ja">Tween インスタンスの継続時間を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get duration():Number { return _duration; }
		public function set duration( value:Number ):void { _duration = value; }
		private var _duration:Number = 0.0;
		
		/**
		 * <span lang="ja">アニメーションのトゥイーン効果を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get easing():Function { return _easing; }
		public function set easing( value:Function ):void { _easing = value; }
		private var _easing:Function;
		
		/**
		 * <span lang="ja">カスタムトゥイーンパラメータを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get parameters():Object { return _parameters; }
		public function set parameters( value:Object ):void { _parameters = value; }
		private var _parameters:Object;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ExecuteEvent.EXECUTE_UPDATE イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see jp.progression.events.ExecuteEvent#EXECUTE_UPDATE
		 */
		public function get onUpdate():Function { return _onUpdate; }
		public function set onUpdate( value:Function ):void { _onUpdate = value; }
		private var _onUpdate:Function;
		
		/**
		 * TransitionManager インスタンスを取得します。
		 */
		private var _manager:TransitionManager;
		
		/**
		 * Transition インスタンスを取得します。
		 */
		private var _transition:Transition;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DoTransition インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoTransition object.</span>
		 * 
		 * @param target
		 * <span lang="ja">トランジション効果を適用する対象の MovieClip オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param type
		 * <span lang="en">Tween インスタンスに適用する Transition です。</span>
		 * <span lang="en"></span>
		 * @param direction
		 * <span lang="en">Tween インスタンスのイージングの方向です。</span>
		 * <span lang="en"></span>
		 * @param duration
		 * <span lang="en">Tween インスタンスの継続時間です。</span>
		 * <span lang="en"></span>
		 * @param easing
		 * <span lang="ja">アニメーションのトゥイーン効果です。</span>
		 * <span lang="en"></span>
		 * @param parameters
		 * <span lang="ja">カスタムトゥイーンパラメータです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoTransition( target:MovieClip, type:Class, direction:int, duration:Number, easing:Function, parameters:Object = null, initObject:Object = null ) {
			// 引数を設定する
			_target = target;
			_type = type;
			_direction = direction;
			_duration = duration;
			_easing = easing;
			_parameters = parameters;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			switch ( _direction ) {
				case Transition.IN		:
				case Transition.OUT		: { break; }
				default					: { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_003 ).toString( "direction" ) ); }
			}
			
			// initObject が DoTransition であれば
			var com:DoTransition = initObject as DoTransition;
			if ( com ) {
				// 特定のプロパティを継承する
				_onUpdate = com._onUpdate;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// パラメータを設定する
			var o:Object = { type:_type, direction:_direction, duration:_duration, easing:_easing };
			for ( var p:String in _parameters ) {
				o[p] ||= _parameters[p];
			}
			
			// TransitionManager を作成する
			_manager = new TransitionManager( _target );
			_manager.addEventListener( "allTransitionsInDone", _transitionDone );
			_manager.addEventListener( "allTransitionsOutDone", _transitionDone );
			
			// TransitionManager を実行する
			_transition = _manager.startTransition( o );
			_transition.addEventListener( "transitionProgress", _transitionProgress );
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interruptFunction():void {
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _transition && _manager ) {
				// Transition を破棄する
				_manager.removeTransition( _transition );
				_manager.removeEventListener( "transitionProgress", _transitionProgress );
				_transition = null;
				
				// イベントリスナーを解除する
				_manager.removeEventListener( "allTransitionsInDone", _transitionDone );
				_manager.removeEventListener( "allTransitionsOutDone", _transitionDone );
				
				// TransitionManager を破棄する
				_manager = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_target = null;
			_type = null;
			_direction = 0;
			_duration = 0;
			_easing = null;
			_parameters = null;
			_onUpdate = null;
		}
		
		/**
		 * <span lang="ja">DoTransition インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoTransition subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoTransition インスタンスです。</span>
		 * <span lang="en">A new DoTransition object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoTransition( _target, _type, _direction, _duration, _easing, _parameters, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "target", "type", "direction", "duration" );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _transitionDone( e:Event ):void {
			// 処理を終了する
			super.executeComplete();
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 
		 */
		private function _transitionProgress( e:Event ):void {
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_UPDATE, false, false, this  ) );
			
			// イベントハンドラメソッドを実行する
			if ( _onUpdate != null ) {
				_onUpdate.apply( scope || this );
			}
		}
	}
}

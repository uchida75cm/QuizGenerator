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
package jp.progression.commands.media {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">DoSound クラスは、Sound の再生を制御するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // DoSound インスタンスを作成する
	 * var com:DoSound = new DoSound();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class DoSound extends Command {
		
		/**
		 * <span lang="ja">再生する Sound オブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get sound():Sound { return _sound; }
		public function set sound( value:Sound ):void { _sound = value; }
		private var _sound:Sound;
		
		/**
		 * <span lang="ja">再生を開始する初期位置（ミリ秒単位）を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get startTime():Number { return _startTime; }
		public function set startTime( value:Number ):void { _startTime = value; }
		private var _startTime:Number = 0;
		
		/**
		 * <span lang="ja">サウンドチャンネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get loops():int { return _loops; }
		public function set loops( value:int ):void { _loops = value; }
		private var _loops:int = 0;
		
		/**
		 * <span lang="ja">サウンドチャンネルに割り当てられる初期 SoundTransform オブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get soundTransform():SoundTransform { return _soundTransform; }
		public function set soundTransform( value:SoundTransform ):void { _soundTransform = value; }
		private var _soundTransform:SoundTransform;
		
		/**
		 * <span lang="ja">サウンドの再生完了を待って、コマンド処理の完了とするかどうかを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get waitForComplete():Boolean { return _waitForComplete; }
		public function set waitForComplete( value:Boolean ):void { _waitForComplete = value; }
		private var _waitForComplete:Boolean = false;
		
		/**
		 * <span lang="ja">再生中の SoundChannel インスタンスを取得します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get soundChannel():SoundChannel { return _soundChannel; }
		private var _soundChannel:SoundChannel;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい DoSound インスタンスを作成します。</span>
		 * <span lang="en">Creates a new DoSound object.</span>
		 * 
		 * @param sound
		 * <span lang="ja">再生する Sound オブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param startTime
		 * <span lang="ja">再生を開始する初期位置（ミリ秒単位）です。</span>
		 * <span lang="en">The initial position in milliseconds at which playback should start.</span>
		 * @param loops
		 * <span lang="ja">サウンドチャンネルの再生が停止するまで startTime 値に戻ってサウンドの再生を繰り返す回数を定義します。</span>
		 * <span lang="en">Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.</span>
		 * @param waitForComplete
		 * <span lang="ja">サウンドの再生完了を待って、コマンド処理の完了とするかどうかです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function DoSound( sound:Sound, startTime:Number = 0, loops:int = 0, waitForComplete:Boolean = false, initObject:Object = null ) {
			// 引数を設定する
			_sound = sound;
			_startTime = startTime;
			_loops = loops;
			_waitForComplete = waitForComplete;
			
			// 親クラスを初期化する
			super( _executeFunction, _interruptFunction, initObject );
			
			// initObject が DoSound であれば
			var com:DoSound = initObject as DoSound;
			if ( com ) {
				// 特定のプロパティを継承する
				_soundTransform = com._soundTransform;
			}
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// オーディオデバイスが存在しなければ終了する
			if ( !Capabilities.hasAudio ) {
				// 処理を終了する
				super.executeComplete();
				return;
			}
			
			// イベントリスナーを登録する
			_sound.addEventListener( IOErrorEvent.IO_ERROR, _ioError, false );
			
			// 再生する
			_soundChannel = _sound.play( _startTime, _loops, _soundTransform );
			
			// 再生完了を待つのであれば
			if ( _waitForComplete ) {
				// イベントリスナーを登録する
				_soundChannel.addEventListener( Event.SOUND_COMPLETE, _soundComplete );
			}
			else {
				// 処理を終了する
				super.executeComplete();
			}
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
			// 対象が存在すれば
			if ( _soundChannel ) {
				// イベントリスナーを解除する
				_soundChannel.removeEventListener( Event.SOUND_COMPLETE, _soundComplete );
				
				// SoundChannel を破棄する
				_soundChannel.stop();
				_soundChannel = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_sound = null;
			_startTime = 0;
			_loops = 0;
			_soundTransform = null;
			_waitForComplete = false;
		}
		
		/**
		 * <span lang="ja">DoSound インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an DoSound subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい DoSound インスタンスです。</span>
		 * <span lang="en">A new DoSound object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new DoSound( _sound, _startTime, _loops, _waitForComplete, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "startTime", "loops", "waitForComplete" );
		}
		
		
		
		
		
		/**
		 * 入出力エラーが発生してロード操作が失敗したときに送出されます。
		 */
		private function _ioError( e:IOErrorEvent ):void {
			super.throwError( this, new IOError( e.text ) );
		}
		
		/**
		 * サウンドの再生が終了したときに送出されます。
		 */
		private function _soundComplete( e:Event ):void {
			// 破棄する
			_destroy();
			
			// 処理を終了する
			super.executeComplete();
		}
	}
}

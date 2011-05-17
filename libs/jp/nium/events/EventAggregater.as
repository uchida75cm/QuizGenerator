/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.events {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * <span lang="ja">登録されている全ての EventDispatcher インスタンスがイベントを送出した場合に送出されます。</span>
	 * <span lang="en">Dispatch when the whole registered EventDispatcher instance sent.</span>
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event( name="complete", type="flash.events.Event" )]
	
	/**
	 * <span lang="ja">EventAggregater クラスは、複数のイベント発生をまとめて処理し、全てのイベントが送出されたタイミングで Event.COMPLETE イベントを送出します。</span>
	 * <span lang="en">EventAggregater class will process the several event generation and send the Event.COMPLETE event when the whole event sent.</span>
	 * 
	 * @example <listing version="3.0">
	 * // EventAggregater インスタンスを作成する
	 * var aggregater:EventAggregater = new EventAggregater();
	 * </listing>
	 */
	public class EventAggregater extends EventDispatcher {
		
		/**
		 * 登録したイベントリスナー情報を取得します。
		 */
		private var _dispatchers:Dictionary;
		
		/**
		 * 登録したイベントリスナー数を取得します。
		 */
		private var _numDispatchers:int = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい EventAggregater インスタンスを作成します。</span>
		 * <span lang="en">Creates a new EventAggregater object.</span>
		 */
		public function EventAggregater() {
			// Dictionary を作成する
			_dispatchers = new Dictionary();
		}
		
		
		
		
		
		/**
		 * <span lang="ja">IEventDispatcher インスタンスを登録します。</span>
		 * <span lang="en">Register the IEventDispatcher instance.</span>
		 * 
		 * @param target
		 * <span lang="ja">登録したい IEventDispatcher インスタンスです。</span>
		 * <span lang="en">The IEventDispatcher instance to register.</span>
		 * @param type
		 * <span lang="ja">登録したいイベントタイプです。</span>
		 * <span lang="en">The event type to register.</span>
		 * @param priority
		 * <span lang="ja">登録したいイベントリスナーの優先度レベルです。優先度は、符号付き 32 ビット整数で指定します。数値が大きくなるほど優先度が高くなります。優先度が n のすべてのリスナーは、優先度が n -1 のリスナーよりも前に処理されます。複数のリスナーに対して同じ優先度が設定されている場合、それらは追加された順番に処理されます。デフォルトの優先度は 0 です。</span>
		 * <span lang="en">The priority level of the event listener to register. The priority is designated by a signed 32-bit integer. The higher the number, the higher the priority. All listeners with priority n are processed before listeners of priority n-1. If two or more listeners share the same priority, they are processed in the order in which they were added. The default priority is 0.</span>
		 * @param useWeakReference
		 * <span lang="ja">登録したいリスナーへの参照が強参照と弱参照のいずれであるかを判断します。デフォルトである強参照の場合は、リスナーのガベージコレクションが回避されます。弱参照では回避されません。</span>
		 * <span lang="en">Determines whether the reference to the listener is strong or weak to register. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not.</span>
		 * 
		 * @see #removeEventDispatcher()
		 */
		public function addEventDispatcher( dispatcher:IEventDispatcher, type:String, useCapture:Boolean = false, priority:int = 0 ):void {
			// 既存のイベントディスパッチャー登録があれば削除する
			removeEventDispatcher( dispatcher, type, useCapture );
			
			// dispatcher の情報を保存する
			_numDispatchers++;
			_dispatchers[_numDispatchers] = {
				id					:_numDispatchers,
				dispatcher			:dispatcher,
				type				:type,
				useCapture			:useCapture,
				priority			:priority,
				dispatched			:false
			};
			
			// イベントリスナーを登録する
			dispatcher.addEventListener( type, _aggregate, useCapture, priority );
		}
		
		/**
		 * <span lang="ja">IEventDispatcher インスタンスの登録を削除します。</span>
		 * <span lang="en">Remove the registered IEventDispatcher instance.</span>
		 * 
		 * @param target
		 * <span lang="ja">削除したい EventDispatcher インスタンスです。</span>
		 * <span lang="en">The IEventDispatcher instance to remove.</span>
		 * @param type
		 * <span lang="ja">削除したいイベントタイプです。</span>
		 * <span lang="en">The event type to remove.</span>
		 * @param useCapture
		 * <span lang="ja">リスナーが、キャプチャ段階、またはターゲットおよびバブリング段階に対して登録されたかどうかを示します。リスナーがキャプチャ段階だけでなくターゲット段階とバブリング段階にも登録されている場合は、removeEventListener() を 2 回呼び出して両方のリスナーを削除する必要があります。1 回は useCapture() を true に設定し、もう 1 回は useCapture() を false に設定する必要があります。</span>
		 * <span lang="en">Specifies whether the listener was registered for the capture phase or the target and bubbling phases. If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, one call with useCapture() set to true, and another call with useCapture() set to false.</span>
		 * 
		 * @see #addEventDispatcher()
		 */
		public function removeEventDispatcher( dispatcher:IEventDispatcher, type:String, useCapture:Boolean = false ):void {
			for each ( var o:Object in _dispatchers ) {
				// 値が違っていれば次へ
				if ( o.dispatcher != dispatcher ) { continue; }
				if ( o.type != type ) { continue; }
				if ( o.useCapture != useCapture ) { continue; }
				
				// イベントリスナーを削除する
				dispatcher.removeEventListener( type, _aggregate, useCapture );
				
				// 情報を削除する
				delete _dispatchers[o.id];
				
				break;
			}
		}
		
		/**
		 * <span lang="ja">登録済みのイベントを全て未発生状態に設定します。</span>
		 * <span lang="en">Set the whole registered event as unsent.</span>
		 */
		public function reset():void {
			// イベント発生を無効化する
			for each ( var o:Object in _dispatchers ) {
				o.dispatched = false;
			}
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
			return "[object EventAggregater]";
		}
		
		
		
		
		
		/**
		 * 任意のイベントの送出を受け取ります。
		 */
		private function _aggregate( e:Event ):void {
			// イベントディスパッチャー情報を走査する
			for each ( var o:Object in _dispatchers ) {
				// 設定値が違っていれば次へ
				if ( o.dispatcher != e.target ) { continue; }
				if ( o.type != e.type ) { continue; }
				
				// イベント発生を有効化する
				o.dispatched = true;
				break;
			}
			
			// イベントが発生していなければ終了する
			for each ( o in _dispatchers ) {
				if ( !o.dispatched ) { return; }
			}
			
			// イベントを送出する
			super.dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}

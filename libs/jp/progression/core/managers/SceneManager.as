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
package jp.progression.core.managers {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.ProcessEvent;
	import jp.progression.events.SceneEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneLoader;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * @private
	 */
	public final class SceneManager {
		
		/**
		 * パッケージ内からの呼び出しかどうかを取得します。
		 */
		private static var _internallyCalled:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">現在地を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get currentSceneId():SceneId { return _currentSceneId; }
		private var _currentSceneId:SceneId;
		
		/**
		 * <span lang="ja">出発地を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get departedSceneId():SceneId { return _departedSceneId; }
		private var _departedSceneId:SceneId;
		
		/**
		 * <span lang="ja">目的地を示すシーン識別子を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get destinedSceneId():SceneId { return _destinedSceneId; }
		private var _destinedSceneId:SceneId;
		
		/**
		 * <span lang="ja">現在のイベントタイプを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get eventType():String { return _eventType; }
		private var _eventType:String;
		
		/**
		 * <span lang="ja">シーン移動処理の実行中に、新しい移動シーケンスの開始を無効化するかどうかを取得または設定します。
		 * このプロパティを設定すると autoLock プロパティが強制的に false に設定されます。</span>
		 * <span lang="en"></span>
		 */
		public function get lock():Boolean { return _lock; }
		public function set lock( value:Boolean ):void {
			var oldLock:Boolean = _lock;
			
			_autoLock = false;
			_lock = value;
			
			if ( _lock != oldLock ) {
				// イベントを送出する
				_target.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_LOCK_CHANGE, false, false, _target ) );
			}
		}
		private var _lock:Boolean = false;
		
		/**
		 * <span lang="ja">シーンの移動シーケンスが開始された場合に、自動的に lock プロパティを true にするかどうかを取得または設定します。
		 * 移動シーケンスが完了後には、lock プロパティは自動的に false に設定されます。</span>
		 * <span lang="en"></span>
		 */
		public function get autoLock():Boolean { return _autoLock; }
		public function set autoLock( value:Boolean ):void { _autoLock = value; }
		private var _autoLock:Boolean = false;
		
		/**
		 * <span lang="ja">現在の処理状態を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.executors.ExecutorObjectState
		 */
		public function get state():int { return _executor ? Math.max( 1, _executor.state ) : 0; }
		
		/**
		 * <span lang="ja">実行時のリレーオブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get extra():Object { return _extra; }
		private var _extra:Object;
		
		/**
		 * 対象となる Progression インスタンスを取得します。
		 */
		private var _target:Progression;
		
		/**
		 * 現在位置となる SceneObject インスタンスを取得します。
		 */
		private var _current:SceneObject;
		
		/**
		 * 実行中の ExecutorObject インスタンスを取得します。
		 */
		private var _executor:ExecutorObject;
		
		/**
		 * 移動シーケンスを実行する準備ができているかどうかを取得します。
		 */
		private var _isReady:Boolean = false;
		
		/**
		 * 
		 */
		private var _isArrived:Boolean = false;
		
		/**
		 * 準備完了前にスタックされた移動先を取得します。
		 */
		private var _stackedDestinedSceneId:SceneId;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SceneManager インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SceneManager object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function SceneManager( target:Progression ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// パッケージ外から呼び出されたら例外をスローする
			if ( !_internallyCalled ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_008 ).toString( "SceneManager" ) ); };
			PackageInfo.activate( target.stage );
			
			// 引数を設定する
			_target = target;
			
			// 初期化する
			_currentSceneId = SceneId.NaS;
			_departedSceneId = SceneId.NaS;
			_destinedSceneId = SceneId.NaS;
			
			// イベントリスナーを登録する
			_target.addEventListener( ManagerEvent.MANAGER_READY, _managerReady );
			
			// 初期化する
			_internallyCalled = false;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal static function $createInstance( target:Progression ):SceneManager {
			_internallyCalled = true;
			return new SceneManager( target );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">シーンを移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">移動先を示すシーン識別子です。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時にコマンドフローをリレーするオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">移動処理が正常に実行された場合は true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #jumpto()
		 * @see #stop()
		 */
		public function goto( sceneId:SceneId, extra:Object = null ):Boolean {
			// ロックされていたら終了する
			if ( _lock ) { return false; }
			
			// 移動先が NaS であれば
			if ( SceneId.isNaS( sceneId ) ) {
				// 例外をスローする
				_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_019 ).toString() ) );
				return false;
			}
			
			// 移動先が管理下に存在しなければ
			if ( !_target.root || !_target.root.sceneId.contains( sceneId ) ) {
				// 例外をスローする
				_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_010 ).toString( sceneId ) ) );
				return false;
			}
			
			// 待機中であれば終了する
			if ( !_isReady ) {
				// 移動予定先に登録する
				_stackedDestinedSceneId = sceneId;
				return false;
			}
			
			// 現在の情報を保持する
			var oldDestinedSceneId:SceneId = _destinedSceneId;
			
			// 出発地と目的地を設定する
			_departedSceneId = _currentSceneId;
			_destinedSceneId = sceneId;
			_current = SceneObject.progression_internal::$getSceneBySceneId( _departedSceneId );
			
			// 引数を設定する
			_extra = extra || {};
			
			// クエリが同一でなければ入れ替える
			if ( !_target.root.sceneInfo.query.equals( sceneId.query ) ) {
				_target.root.sceneInfo.progression_internal::$query = sceneId.query.clone( true );
			}
			
			// すでに到着していて、かつ現在の移動先と新しい移動先が同一であれば終了する
			if ( _isArrived && oldDestinedSceneId.equals( sceneId ) ) { return false; }
			
			// 状態を変更する
			_isArrived = false;
			
			// すでに実行中であれば
			if ( _executor ) {
				// イベントを送出する
				_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_CHANGE, false, false, _current, _eventType ) );
				return true;
			}
			
			// autoLock が有効化されていれば
			if ( _autoLock && !_lock ) {
				_lock = true;
				
				// イベントを送出する
				_target.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_LOCK_CHANGE, false, false, _target ) );
			}
			
			// イベントを送出する
			_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_START, false, false, _current, _eventType ) );
			
			// 移動処理を開始する
			return _gotoProgress();
		}
		
		/**
		 * 移動処理の実装です。
		 */
		private function _gotoProgress():Boolean {
			// 現在のシーン情報を保存する
			var previousSceneId:SceneId = _currentSceneId;
			var previousEventType:String = _eventType;
			
			// 現在のシーンが NaS であれば
			if ( SceneId.isNaS( _currentSceneId ) ) {
				_currentSceneId = _target.root.sceneId.transfer( "./", _destinedSceneId.query );
				_eventType = SceneEvent.SCENE_LOAD;
			}
			// 目的のシーンと現在のシーンが同じであれば
			else if ( _currentSceneId.equals( _destinedSceneId ) ) {
				switch ( _eventType ) {
					case SceneEvent.SCENE_PRE_LOAD			: { _eventType = SceneEvent.SCENE_LOAD; break; }
					case SceneEvent.SCENE_LOAD				: { _eventType = SceneEvent.SCENE_INIT; break; }
					case SceneEvent.SCENE_INIT				: {
						// シーン移動を完了する
						_current = SceneObject.progression_internal::$getSceneBySceneId( _currentSceneId );
						_gotoComplete();
						return true;
					}
					case SceneEvent.SCENE_GOTO				:
					case SceneEvent.SCENE_DESCEND			:
					case SceneEvent.SCENE_ASCEND			: { _eventType = SceneEvent.SCENE_INIT; break; }
					case SceneEvent.SCENE_UNLOAD			: { _eventType = SceneEvent.SCENE_LOAD; break; }
					case SceneEvent.SCENE_POST_UNLOAD		: { _eventType = SceneEvent.SCENE_PRE_LOAD; break; }
				}
			}
			// 目的のシーンが現在のシーンの子であれば
			else if ( _currentSceneId.contains( _destinedSceneId ) ) {
				switch ( _eventType ) {
					case SceneEvent.SCENE_PRE_LOAD			: { _eventType = SceneEvent.SCENE_LOAD; break; }
					case SceneEvent.SCENE_LOAD				: { _eventType = SceneEvent.SCENE_DESCEND; break; }
					case SceneEvent.SCENE_INIT				: { _eventType = SceneEvent.SCENE_GOTO; break; }
					case SceneEvent.SCENE_GOTO				:
					case SceneEvent.SCENE_DESCEND			: {
						// 子シーンに移動する
						_currentSceneId = _currentSceneId.transfer( _destinedSceneId.getNameByIndex( _currentSceneId.length ), _destinedSceneId.query );
						_eventType = SceneEvent.SCENE_LOAD;
						break;
					}
					case SceneEvent.SCENE_ASCEND			: { _eventType = SceneEvent.SCENE_DESCEND; break; }
					case SceneEvent.SCENE_UNLOAD			: { _eventType = SceneEvent.SCENE_LOAD; break; }
					case SceneEvent.SCENE_POST_UNLOAD		: { _eventType = SceneEvent.SCENE_PRE_LOAD; break; }
				}
			}
			// 目的のシーンが現在のシーンの親もしくは親戚であれば
			else {
				switch ( _eventType ) {
					case SceneEvent.SCENE_PRE_LOAD			: { _eventType = SceneEvent.SCENE_POST_UNLOAD; break; }
					case SceneEvent.SCENE_LOAD				: { _eventType = SceneEvent.SCENE_UNLOAD; break; }
					case SceneEvent.SCENE_INIT				: { _eventType = SceneEvent.SCENE_GOTO; break; }
					case SceneEvent.SCENE_GOTO				: { _eventType = SceneEvent.SCENE_UNLOAD; break; }
					case SceneEvent.SCENE_DESCEND			: { _eventType = SceneEvent.SCENE_ASCEND; break; }
					case SceneEvent.SCENE_ASCEND			: { _eventType = SceneEvent.SCENE_UNLOAD; break; }
					case SceneEvent.SCENE_UNLOAD			:
					case SceneEvent.SCENE_POST_UNLOAD		: {
						// 親シーンに移動する
						_currentSceneId = _currentSceneId.transfer( "../", _destinedSceneId.query );
						
						// 現在地と目的地のシーンがルートシーンであれば
						if ( _currentSceneId.equals( _target.root.sceneId ) && _destinedSceneId.equals( _target.root.sceneId ) ) {
							// ルートシーンに移動する
							_currentSceneId = _target.root.sceneId.transfer( "./", _destinedSceneId.query );
							_eventType = SceneEvent.SCENE_INIT;
						}
						// 目的のシーンと移動先のシーンが同一であれば
						else if ( _currentSceneId.equals( _destinedSceneId ) ) {
							_eventType = SceneEvent.SCENE_INIT;
						}
						// 目的のシーンが移動先のシーンの子であれば
						else if ( _currentSceneId.contains( _destinedSceneId ) ) {
							_currentSceneId = _currentSceneId.transfer( _destinedSceneId.getNameByIndex( _currentSceneId.length ), _destinedSceneId.query );
							_eventType = SceneEvent.SCENE_LOAD;
						}
						// 目的のシーンが移動先のシーンの親シーンであれば
						else {
							_eventType = SceneEvent.SCENE_ASCEND;
						}
						
						break;
					}
				}
			}
			
			// シーン識別子からシーンの参照を取得する
			_current = SceneObject.progression_internal::$getSceneBySceneId( _currentSceneId );
			var previous:SceneObject = SceneObject.progression_internal::$getSceneBySceneId( previousSceneId );
			var loader:SceneLoader = _current as SceneLoader;
			
			// 現在のシーンが SceneLoader であり、コンテンツが読み込まれていなければ
			if ( loader && !loader.content ) {
				switch ( _eventType ) {
					case SceneEvent.SCENE_PRE_LOAD			: { break; }
					case SceneEvent.SCENE_LOAD				: {
						switch ( previousEventType ) {
							case SceneEvent.SCENE_PRE_LOAD	: {
								_current = null;
								_currentSceneId = previousSceneId;
								break;
							}
							case SceneEvent.SCENE_UNLOAD	: {
								if ( previous.sceneInfo.loader ) {
									_current = previous.sceneInfo.loader;
									_currentSceneId = previousSceneId;
									_eventType = SceneEvent.SCENE_POST_UNLOAD;
								}
								else {
									_current = _current;
									_eventType = SceneEvent.SCENE_PRE_LOAD;
								}
								break;
							}
							default							: { _eventType = SceneEvent.SCENE_PRE_LOAD; }
						}
						break;
					}
					case SceneEvent.SCENE_INIT				:
					case SceneEvent.SCENE_GOTO				:
					case SceneEvent.SCENE_DESCEND			:
					case SceneEvent.SCENE_ASCEND			:
					case SceneEvent.SCENE_UNLOAD			:
					case SceneEvent.SCENE_POST_UNLOAD		: { break; }
				}
			}
			// ひとつ前のシーンが存在し、かつルートであり、SceneLoader に読み込まれていれば
			else if ( previous && previous.root == previous && previous.sceneInfo.loader ) {
				switch ( previousEventType ) {
					case SceneEvent.SCENE_PRE_LOAD			:
					case SceneEvent.SCENE_LOAD				:
					case SceneEvent.SCENE_INIT				:
					case SceneEvent.SCENE_GOTO				:
					case SceneEvent.SCENE_DESCEND			:
					case SceneEvent.SCENE_ASCEND			: { break; }
					case SceneEvent.SCENE_UNLOAD			: {
						_current = previous.sceneInfo.loader;
						_currentSceneId = previousSceneId;
						_eventType = SceneEvent.SCENE_POST_UNLOAD;
					}
					case SceneEvent.SCENE_POST_UNLOAD		: { break; }
				}
			}
			
			// 現在のシーンが存在しなければ
			if ( !_current ) {
				// 存在しないシーン識別子を取得する
				var unexistSceneId:SceneId = _currentSceneId;
				
				// ひとつ前のシーンに戻る
				_current = previous;
				_currentSceneId = previousSceneId;
				_eventType = previousEventType;
				
				// 例外をスローする
				if ( loader ) {
					_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_009 ).toString( unexistSceneId ) ) );
				}
				else {
					_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_010 ).toString( unexistSceneId ) ) );
				}
				
				return false;
			}
			
			// シーンが変更されていればイベントを送出する
			switch ( true ) {
				case _current == null									:
				case _current == previous								:
				case previousEventType == SceneEvent.SCENE_PRE_LOAD		:
				case _eventType == SceneEvent.SCENE_POST_UNLOAD			: { break; }
				default													: { _target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_SCENE, false, false, _current, _eventType ) ); }
			}
			
			// イベントを送出する
			_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_EVENT, false, false, _current, _eventType ) );
			
			// ExecutorObject を取得する
			_executor = _current.executor;
			
			// ExecutorObject が存在すれば
			if ( _executor ) {
				// イベントリスナーを登録する
				_executor.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_executor.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_executor.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _executeError );
				
				// 実行する
				_executor.execute( new SceneEvent( _eventType, false, false, _eventType ), _extra );
			}
			else {
				// イベントを送出する
				_current.dispatchEvent( new SceneEvent( _eventType, false, false, _eventType ) );
				
				// 移動処理を完了する
				_gotoComplete();
			}
			
			return true;
		}
		
		/**
		 * 移動処理完了後の処理です。
		 */
		private function _gotoComplete():void {
			// 目的のシーンに到着して、かつイベントタイプが SceneEvent.SCENE_INIT であれば
			if ( _currentSceneId.equals( _destinedSceneId ) && _eventType == SceneEvent.SCENE_INIT ) {
				// イベントを送出する
				_current.dispatchEvent( new SceneEvent( SceneEvent.SCENE_INIT_COMPLETE, false, false, _eventType ) );
				
				// 目的のシーンに到着して、かつイベントタイプが SceneEvent.SCENE_INIT であれば
				if ( _currentSceneId.equals( _destinedSceneId ) && _eventType == SceneEvent.SCENE_INIT ) {
					// 現在のシーンを取得する
					var current:SceneObject = _current;
					
					// 状態を変更する
					_isArrived = true;
					
					// 破棄する
					_destroy();
					
					// イベントを送出する
					_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_COMPLETE, false, false, current, _eventType ) );
					return;
				}
			}
			
			// 処理を開始する
			_gotoProgress();
		}
		
		/**
		 * <span lang="ja">シーン移動に関係した処理を全て無視して、すぐに移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param sceneId
		 * <span lang="ja">移動先を示すシーン識別子です。</span>
		 * <span lang="en"></span>
		 * @param extra
		 * <span lang="ja">実行時にコマンドフローをリレーするオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">移動処理が正常に実行された場合は true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see #stop()
		 */
		public function jumpto( sceneId:SceneId, extra:Object = null ):Boolean {
			// ロックされていたら終了する
			if ( _lock ) { return false; }
			
			// 移動先が NaS であれば
			if ( SceneId.isNaS( sceneId ) ) {
				// 例外をスローする
				_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_019 ).toString() ) );
				return false;
			}
			
			// 移動先が管理下に存在しなければ
			if ( !_target.root || !_target.root.sceneId.contains( sceneId ) ) {
				// 例外をスローする
				_throwError( new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_010 ).toString( sceneId ) ) );
				return false;
			}
			
			// 待機中であれば終了する
			if ( !_isReady ) {
				// 移動予定先に登録する
				_stackedDestinedSceneId = sceneId;
				return false;
			}
			
			// 出発地と目的地を設定する
			_departedSceneId = _currentSceneId;
			_destinedSceneId = sceneId;
			
			// 引数を設定する
			_extra = extra || {};
			
			// クエリが同一でなければ入れ替える
			if ( !_target.root.sceneInfo.query.equals( sceneId.query ) ) {
				_target.root.sceneInfo.progression_internal::$query = sceneId.query.clone( true );
			}
			
			// すでに実行中であれば
			if ( _executor ) {
				// イベントを送出する
				_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_CHANGE, false, false, _current, _eventType ) );
				return true;
			}
			
			// autoLock が有効化されていれば
			if ( _autoLock && !_lock ) {
				_lock = true;
				
				// イベントを送出する
				_target.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_LOCK_CHANGE, false, false, _target ) );
			}
			
			// イベントを送出する
			_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_START, false, false, _current, _eventType ) );
			
			// 移動する
			_current = SceneObject.progression_internal::$getSceneBySceneId( _destinedSceneId );
			_currentSceneId = _current.sceneId;
			_eventType = SceneEvent.SCENE_INIT;
			
			// 破棄する
			_destroy();
			
			// イベントを送出する
			_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_COMPLETE, false, false, _current, _eventType ) );
			
			return true;
		}
		
		/**
		 * <span lang="ja">シーン移動処理を中断します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #goto()
		 * @see #jumpto()
		 */
		public function stop():void {
			// ExecutorObject が存在して、実行中であれば
			if ( _executor && _executor.state > 0 ) {
				_executor.interrupt();
			}
		}
		
		/**
		 * 例外をスローします。
		 */
		private function _throwError( e:Error ):void {
			// 現在の状態を保持する
			var current:SceneObject = _current;
			var eventType:String = _eventType;
			
			// 破棄する
			_destroy();
			
			// イベントリスナーが設定されていれば
			if ( _target.hasEventListener( ProcessEvent.PROCESS_ERROR ) ) {
				// イベントを送出する
				_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_ERROR, false, false, current, eventType, _target, e ) );
			}
			else {
				// 例外をスローする
				throw e;
			}
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			// イベントリスナーを解除する
			_removeExecutorListeners();
			
			// autoLock が有効化されていれば
			if ( _autoLock && _lock ) {
				_lock = false;
				
				// イベントを送出する
				_target.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_LOCK_CHANGE, false, false, _target ) );
			}
			
			// Executor が存在して、実行中であれば
			if ( _executor && _executor.state > 0 ) {
				_executor.interrupt();
			}
			
			// 破棄する
			_extra = null;
			_current = null;
			_executor = null;
		}
		
		/**
		 * ExecutorObject のリスナーを解除します。
		 */
		private function _removeExecutorListeners():void {
			// 対象が存在すれば
			if ( _executor ) {
				// イベントリスナーを解除する
				_executor.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_executor.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_executor.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _executeError );
			}
		}
		
		/**
		 * @private
		 */
		progression_internal function $dispose():void {
			// イベントリスナーを解除する
			_removeExecutorListeners();
			
			// 破棄する
			_currentSceneId = null;
			_departedSceneId = null;
			_destinedSceneId = null;
			_target = null;
			_current = null;
			_extra = null;
			_executor = null;
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _managerReady( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			_target.removeEventListener( ManagerEvent.MANAGER_READY, _managerReady );
			
			// 準備完了状態にする
			_isReady = true;
			
			// 現在の移動先が存在すれば
			if ( _stackedDestinedSceneId ) {
				goto( _stackedDestinedSceneId, _extra );
			}
		}
		
		/**
		 * 処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// イベントリスナーを解除する
			_removeExecutorListeners();
			
			// 移動処理を完了する
			_gotoComplete();
		}
		
		/**
		 * 処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// 終了処理を実行する
			_destroy();
			
			// イベントを送出する
			_target.dispatchEvent( new ProcessEvent( ProcessEvent.PROCESS_STOP, false, false, _current, _eventType ) );
		}
		
		/**
		 * 処理の途中でエラーが発生した場合に送出されます。
		 */
		private function _executeError( e:ExecuteErrorEvent ):void {
			// 終了処理を実行する
			_destroy();
			
			// 例外をスローする
			_throwError( e.errorObject );
		}
	}
}

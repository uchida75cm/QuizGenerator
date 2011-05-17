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
package jp.progression.commands.net {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">UploadFileRef クラスは、ユーザーが選択したファイルをリモートサーバーにアップロードするコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // UploadFileRef インスタンスを作成する
	 * var com:UploadFileRef = new UploadFileRef();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class UploadFileRef extends LoadCommand {
		
		/**
		 * <span lang="ja">ユーザーのコンピュータとサーバーとの通信に使用する FileReference インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get fileReference():FileReference { return _fileReference; }
		public function set fileReference( value:FileReference ):void { _fileReference = value; }
		private var _fileReference:FileReference;
		private var __fileReference:FileReference;
		
		/**
		 * <span lang="ja">ダイアログボックスに表示するファイルをフィルタにかける場合に使用する FileFilter インスタンスの配列です。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en">An array of FileFilter instances used to filter the files that are displayed in the dialog box.
		 * </span>
		 */
		public function get typeFilter():Array { return _typeFilter; }
		public function set typeFilter( value:Array ):void { _typeFilter = value; }
		private var _typeFilter:Array;
		
		/**
		 * <span lang="ja">アップロード POST 操作のファイルデータに先行するフィールド名です。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en">The field name that precedes the file data in the upload POST operation.
		 * </span>
		 */
		public function get uploadDataFieldName():String { return _uploadDataFieldName; }
		public function set uploadDataFieldName( value:String ):void { _uploadDataFieldName = value; }
		private var _uploadDataFieldName:String = "Filedata";
		private var __uploadDataFieldName:String = "Filedata";
		
		/**
		 * <span lang="ja">テストファイルアップロードを要求するための設定です。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en">A setting to request a test file upload.
		 * </span>
		 */
		public function get testUpload():Boolean { return _testUpload; }
		public function set testUpload( value:Boolean ):void { _testUpload = value; }
		private var _testUpload:Boolean = false;
		private var __testUpload:Boolean = false;
		
		/**
		 * @private
		 */
		override public function get cacheAsResource():Boolean { return false; }
		override public function set cacheAsResource( value:Boolean ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "cacheAsResource" ) ); }
		
		/**
		 * @private
		 */
		override public function get preventCache():Boolean { return false; }
		override public function set preventCache( value:Boolean ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "preventCache" ) ); }
		
		/**
		 * @private
		 */
		override public function get data():* { return null; }
		override public function set data( value:* ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "data" ) ); }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい UploadFileRef インスタンスを作成します。</span>
		 * <span lang="en">Creates a new UploadFileRef object.</span>
		 * 
		 * @param request
		 * <span lang="en">URLRequest オブジェクトです。</span>
		 * <span lang="en">The URLRequest object.</span>
		 * @param fileReference
		 * <span lang="ja">ユーザーのコンピュータとサーバーとの通信に使用する FileReference インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function UploadFileRef( request:URLRequest, fileReference:FileReference = null, initObject:Object = null ) {
			// 引数を設定する
			_fileReference = fileReference;
			
			// 初期化する
			_typeFilter = [];
			
			// 親クラスを初期化する
			super( request, initObject );
			
			// 特定の機能を無効化する
			super.cacheAsResource = false;
			super.preventCache = false;
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override protected function executeFunction():void {
			// 現在の状態を保存する
			__fileReference = _fileReference || new FileReference();
			__uploadDataFieldName = _uploadDataFieldName;
			__testUpload = _testUpload;
			
			// ファイルを参照する
			if ( __fileReference.browse( _typeFilter ) ) {
				__fileReference.addEventListener( Event.SELECT, _select );
				__fileReference.addEventListener( Event.CANCEL, _completeAndCancel );
			}
			else {
				_completeAndCancel( null );
			}
		}
		
		/**
		 * @private
		 */
		override protected function interruptFunction():void {
			// 実行中の処理をキャンセルする
			__fileReference.cancel();
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			// イベントリスナーを解除する
			__fileReference.removeEventListener( Event.SELECT, _select );
			__fileReference.removeEventListener( Event.CANCEL, _completeAndCancel );
			__fileReference.removeEventListener( Event.COMPLETE, _completeAndCancel );
			__fileReference.removeEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			__fileReference.removeEventListener( IOErrorEvent.IO_ERROR, _ioError );
			__fileReference.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
			
			// 破棄する
			__fileReference = null;
			__uploadDataFieldName = null;
			__testUpload = false;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_fileReference = null;
			_typeFilter = null;
			_uploadDataFieldName = null;
			_testUpload = false;
		}
		
		/**
		 * <span lang="ja">UploadFileRef インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an UploadFileRef subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい UploadFileRef インスタンスです。</span>
		 * <span lang="en">A new UploadFileRef object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new UploadFileRef( super.request );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "url", "uploadDataFieldName", "testUpload", "factor" );
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _select( e:Event ):void {
			// イベントリスナーを登録する
			__fileReference.addEventListener( Event.CANCEL, _completeAndCancel );
			__fileReference.addEventListener( Event.COMPLETE, _completeAndCancel );
			__fileReference.addEventListener( ProgressEvent.PROGRESS, super.dispatchEvent );
			__fileReference.addEventListener( IOErrorEvent.IO_ERROR, _ioError );
			__fileReference.addEventListener( SecurityErrorEvent.SECURITY_ERROR, _securityError );
			
			// アップロードを開始する
			__fileReference.upload( super.request, __uploadDataFieldName, __testUpload );
		}
		
		/**
		 * 
		 */
		private function _completeAndCancel( e:Event ):void {
			// 破棄する
			_destroy();
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * 
		 */
		private function _ioError( e:IOErrorEvent ):void {
			// エラー処理を実行する
			super.throwError( this, new IOError( e.text ) );
		}
		
		/**
		 * 
		 */
		private function _securityError( e:SecurityErrorEvent ):void {
			// エラー処理を実行する
			super.throwError( this, new SecurityError( e.text ) );
		}
	}
}

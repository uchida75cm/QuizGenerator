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
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">SendToURL クラスは、	URL リクエストをサーバーに送信操作を行うコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // SendToURL インスタンスを作成する
	 * var com:SendToURL = new SendToURL();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class SendToURL extends Command {
		
		/**
		 * <span lang="ja">リクエストされる URL を示すストリングを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get url():String { return _request ? _request.url : null; }
		
		/**
		 * <span lang="ja">リクエストされる URL です。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en">The URL to be requested.
		 * </span>
		 */
		public function get request():URLRequest { return _request; }
		public function set request( value:URLRequest ):void { _request = value; }
		private var _request:URLRequest;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SendToURL インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SendToURL object.</span>
		 * 
		 * @param request
		 * <span lang="ja">データの送信先の URL を指定する URLRequest オブジェクトです。</span>
		 * <span lang="en">A URLRequest object specifying the URL to send data to.</span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function SendToURL( request:URLRequest, initObject:Object = null ) {
			// 引数を設定する
			_request = request;
			
			// 親クラスを初期化する
			super( _executeFunction, null, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// データを送信する
			sendToURL( _request );
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_request = null;
		}
		
		/**
		 * <span lang="ja">SendToURL インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an SendToURL subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい SendToURL インスタンスです。</span>
		 * <span lang="en">A new SendToURL object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new SendToURL( _request );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "url" );
		}
	}
}

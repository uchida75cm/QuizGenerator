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
package jp.progression.commands {
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">Prop クラスは、指定された対象の複数のプロパティを一括で設定するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // Sprite インスタンスを作成する
	 * var sp:Sprite = new Sprite();
	 * 
	 * // Prop インスタンスを作成する
	 * var com:Prop = new Prop( sp, {
	 * 	x:100,
	 * 	y:200,
	 * 	rotation:30
	 * } );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Prop extends Command {
		
		/**
		 * <span lang="ja">プロパティを設定したい対象のオブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #parameters
		 */
		public function get target():Object { return _target; }
		public function set target( value:Object ):void { _target = value; }
		private var _target:Object;
		
		/**
		 * <span lang="ja">対象に設定したいプロパティを含んだオブジェクトを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #target
		 */
		public function get parameters():Object { return _parameters; }
		public function set parameters( value:Object ):void { _parameters = value; }
		private var _parameters:Object;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Prop インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Prop object.</span>
		 * 
		 * @param target
		 * <span lang="ja">一括設定したいオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param parameters
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Prop( target:*, parameters:Object, initObject:Object = null ) {
			// 引数を設定する
			_target = target;
			_parameters = parameters;
			
			// 親クラスを初期化する
			super( _executeFunction, null, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			var list:Array = _target as Array || [ _target ];
			
			// プロパティを設定する
			for ( var i:int = 0, l:int = list.length; i < l; i++ ) {
				ObjectUtil.setProperties( list[i], _parameters );
			}
			
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
			
			_target = null;
			_parameters = null;
		}
		
		/**
		 * <span lang="ja">Prop インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Prop subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Prop インスタンスです。</span>
		 * <span lang="en">A new Prop object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Prop( _target, _parameters, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "target" );
		}
	}
}

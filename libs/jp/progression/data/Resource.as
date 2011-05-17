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
package jp.progression.data {
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import jp.nium.collections.IdGroupCollection;
	import jp.nium.collections.IIdGroup;
	import jp.nium.collections.UniqueList;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">Resource クラスは、汎用的なリソース管理機能を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.data#getResourceById()
	 * @see jp.progression.data#getResourcesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // Resource インスタンスを作成する
	 * var res:Resource = new Resource();
	 * </listing>
	 */
	public class Resource implements IIdGroup, IDisposable {
		
		/**
		 * @private
		 */
		progression_internal static const $collection:IdGroupCollection = new IdGroupCollection();
		
		/**
		 * 全てのインスタンスを保存した UniqueList 配列を取得します。
		 */
		private static var _resources:UniqueList = new UniqueList();
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスを表すユニークな識別子を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.resources#getResourceByUrl()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_013 ).toString( "id" ) );
		}
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the Resource.</span>
		 * 
		 * @see jp.progression.resources#getResourcesByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			_group = Resource.progression_internal::$collection.registerGroup( this, value ) ? value : null; 
		}
		private var _group:String;
		
		/**
		 * <span lang="ja">保持しているデータを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get data():* { return _data; }
		public function set data( value:* ):void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			_data = value;
		}
		private var _data:*;
		
		/**
		 * <span lang="ja">保持している ByteArray 形式のデータを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get bytes():ByteArray { return _bytes; }
		public function set bytes( value:ByteArray ):void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			_bytes = value;
		}
		private var _bytes:ByteArray;
		
		/**
		 * <span lang="ja">読み込まれたデータの総ファイルサイズを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get bytesTotal():uint { return _bytesTotal; }
		public function set bytesTotal( value:uint ):void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			_bytesTotal = value;
		}
		private var _bytesTotal:uint = 0;
		
		/**
		 * 破棄されているかどうかを取得します。
		 */
		private var _disposed:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Resource インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Resource object.</span>
		 * 
		 * @param url
		 * <span lang="ja">インスタンスを表すユニークな識別子です。</span>
		 * <span lang="en"></span>
		 * @param data
		 * <span lang="ja">保持したいデータです。</span>
		 * <span lang="en"></span>
		 * @param bytes
		 * <span lang="ja">保持したい ByteArray 形式のデータです。</span>
		 * <span lang="en"></span>
		 * @param bytesTotal
		 * <span lang="ja">読み込まれたデータの総ファイルサイズです。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Resource( id:String, data:*, bytes:ByteArray = null, bytesTotal:uint = 0, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 既存の登録を取得する
			var res:Resource = Resource.progression_internal::$collection.getInstanceById( id ) as Resource;
			
			// すでに存在していれば
			if ( res ) {
				res.dispose();
			}
			
			// 引数を設定する
			_id = id;
			_data = data;
			_bytes = bytes;
			_bytesTotal = bytesTotal;
			
			// コレクションに登録する
			Resource.progression_internal::$collection.addInstance( this );
			if ( !Resource.progression_internal::$collection.registerId( this, id ) ) {
				_id = null;
			}
			_resources.addItem( this );
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			// 登録を解除する
			Resource.progression_internal::$collection.registerId( this, null );
			_resources.removeItem( this );
			
			// データを破棄する
			_id = null;
			_group = null;
			_data = null;
			_bytes = null;
			_bytesTotal = 0;
			
			_disposed = true;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの BitmapData 表現を返します。</span>
		 * <span lang="en">Returns the BitmapData representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの BitmapData 表現です。</span>
		 * <span lang="en">A BitmapData representation of the object.</span>
		 */
		public function toBitmapData():BitmapData {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			return _data as BitmapData;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの BitmapData 表現を返します。</span>
		 * <span lang="en">Returns the BitmapData representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの BitmapData 表現です。</span>
		 * <span lang="en">A BitmapData representation of the object.</span>
		 */
		public function toByteArray():ByteArray {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			return _bytes;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの Loader 表現を返します。</span>
		 * <span lang="en">Returns the Loader representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの Loader 表現です。</span>
		 * <span lang="en">A Loader representation of the object.</span>
		 */
		public function toLoader():Loader {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			return _data as Loader;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの Sound 表現を返します。</span>
		 * <span lang="en">Returns the Sound representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの Sound 表現です。</span>
		 * <span lang="en">A Sound representation of the object.</span>
		 */
		public function toSound():Sound {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			return _data as Sound;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトの XML 表現を返します。</span>
		 * <span lang="en">Returns the XML representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトの XML 表現です。</span>
		 * <span lang="en">A XML representation of the object.</span>
		 */
		public function toXML():XML {
			if ( _disposed ) { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_025 ).toString( toString() ) ); }
			
			switch ( true ) {
				case _data is String	: { return new XML( _data ); }
				case _data is XML		: { return _data; }
			}
			
			return _data as XML;
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		public function toString():String {
			if ( _disposed ) { return ObjectUtil.formatToString( this, "Resource" ); }
			
			return String( _data );
		}
	}
}

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
package jp.nium.net {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.nium.utils.StringUtil;
	
	/**
	 * <span lang="ja">Query クラスは、URL のクエリパラメータを ActionScript で制御しやすい形に表現したモデルクラスです。</span>
	 * <span lang="en">Query class is a model class which express the query parameter of the URL that can handle by ActionScript easily.</span>
	 * 
	 * @example <listing version="3.0">
	 * // Query インスタンスを作成する
	 * var query:Query = new Query();
	 * </listing>
	 */
	public dynamic class Query extends Proxy {
		
		/**
		 * プロパティ名の形式を確認する正規表現を取得します。
		 */
		private static const _NAME_REGEXP:String = "^[a-z]\\w*$";
		
		
		
		
		
		/**
		 * 読み取り専用かどうかを取得します。
		 */
		private var _readOnly:Boolean = false;
		
		/**
		 * 設定されているプロパティを取得します。
		 */
		private var _properties:Object;
		
		/**
		 * 設定されているプロパティを配列で取得します。
		 */
		private var _propertyList:Array;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Query インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Query object.</span>
		 * 
		 * @param query
		 * <span lang="ja">初期値となるオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param readOnly
		 * <span lang="ja">インスタンスを読み取り専用にするかどうかです。</span>
		 * <span lang="en"></span>
		 */
		public function Query( query:* = null, readOnly:Boolean = false ) {
			// 初期化する
			_properties = {};
			_propertyList = [];
			
			// 初期値を設定する
			switch ( true ) {
				case query is String	: {
					var queries:Array = query ? query.split( "&" ) : [];
					for ( var i:int = 0, l:int = queries.length; i < l; i++ ) {
						var item:Array = String( queries[i] ).split( "=" );
						flash_proxy::setProperty( item[0], StringUtil.toProperType( item[1] ) );
					}
					break;
				}
				case query is Query		: { query = Query( query )._properties; }
				case query is Object	: {
					for ( var p:String in query ) {
						flash_proxy::setProperty( p, query[p] );
					}
					break;
				}
			}
			
			// 引数を設定する
			_readOnly = readOnly;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定された Query オブジェクトが、対象 Query オブジェクトと同一内容かどうかを返します。</span>
		 * <span lang="en">Returns if the specified Query object has the same content with the Query object.</span>
		 * 
		 * @param sceneId
		 * <span lang="ja">テストする Query オブジェクトです。</span>
		 * <span lang="en">The Query object to test.</span>
		 * @return
		 * <span lang="ja">同一内容の Query オブジェクトであれば true に、それ以外の場合は false になります。</span>
		 * <span lang="en">Returns true if the Query object has same content, otherwise return false.</span>
		 */
		public function equals( query:Query ):Boolean {
			var props1:Array = [];
			var props2:Array = [];
			
			// 配列化する
			for ( var p1:String in _properties ) {
				props1.push( p1 );
			}
			for ( var p2:String in query._properties ) {
				props2.push( p2 );
			}
			
			// 長さが違っていれば
			if ( props1.length != props2.length ) { return false; }
			
			// 内容が違っていれば
			for ( var i:int = 0, l:int = props1.length; i < l; i++ ) {
				var name:String = props1[i];
				if ( _properties[name] != query._properties[name] ) { return false; };
			}
			
			return true;
		}
		
		/**
		 * <span lang="ja">Query インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Query subclass.</span>
		 * 
		 * @param readOnly
		 * <span lang="ja">インスタンスを読み取り専用にするかどうかです。</span>
		 * <span lang="en">If the instance is read only or not.</span>
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Query インスタンスです。</span>
		 * <span lang="en">A new Query object that is identical to the original.</span>
		 */
		public function clone( readOnly:Boolean = false ):Query {
			return new Query( _properties, readOnly );
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
			return ObjectUtil.toQueryString( _properties );
		}
		
		/**
		 * @private
		 */
		override flash_proxy function callProperty( methodName:*, ... args:Array ):* {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( methodName ) );
		}
		
		/**
		 * @private
		 */
		override flash_proxy function getProperty( name:* ):* {
			return _properties[name];
		}
		
		/**
		 * @private
		 */
		override flash_proxy function setProperty( name:*, value:* ):void {
			// 読み取り専用の値を変更しようとしたら
			if ( _readOnly ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_013 ).toString( name ) ); }
			if ( !new RegExp( _NAME_REGEXP, "i" ).test( name ) ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_015 ).toString() ); }
			
			switch ( true ) {
				case value == null			:
				case value == undefined		:
				case value is Boolean		:
				case value is Number		:
				case value is int			:
				case value is uint			:
				case value is String		: { break; }
				default						: { value = String( value ); }
			}
			
			// 値を設定する
			_properties[name] = value;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function deleteProperty( name:* ):Boolean {
			// 読み取り専用の値を消去しようとしたら
			if ( _readOnly ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_013 ).toString( name ) ); }
			
			return delete _properties[name];
		}
		
		/**
		 * @private
		 */
		override flash_proxy function hasProperty( name:* ):Boolean {
			return name in _properties;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextNameIndex( index:int ):int {
			if ( index == 0 ) {
				_propertyList = [];
				for ( var p:* in _properties ) {
					_propertyList.push( p );
				}
			}
			
			return ( index < _propertyList.length ) ? index + 1 : 0;
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextName( index:int ):String {
			return _propertyList[index - 1];
		}
		
		/**
		 * @private
		 */
		override flash_proxy function nextValue( index:int ):* {
			return _properties[_propertyList[index - 1]];
		}
	}
}

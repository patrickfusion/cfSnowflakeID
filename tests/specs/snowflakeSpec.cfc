component extends="testbox.system.BaseSpec" {

	function run() {
		describe( "snowflake spec", () => {
			feature( "constructor options", () => {
				given( "I am created a new snowflake instance", () => {
					when( "I use the default constructor arguments", () => {
						then( "It should return a configured snowflake instance", () => {
							var model = new cfSnowflakeID.snowflake();
							expect( model ).toBeInstanceOf( "snowflake" );
							expect( model.getNodeID() ).toBe( 0 );
							expect( model.getCustomEpoch() ).toBe( 1420070400000, "expected 1 January 2015 00:00:00" );
						} );
					} );
					when( "I use a customEpoch", () => {
						then( "It should use the custom epoch", () => {
							var model = new cfSnowflakeID.snowflake( customEpoch=1577836800000 );
							expect( model ).toBeInstanceOf( "snowflake" );
							expect( model.getCustomEpoch() ).toBe( 1577836800000, "expected 1 January 2020 00:00:00" );
						} );
					} );
					when( "I use a nodeid outside the allowed range", () => {
						then( "It should throw an error for a negative value", () => {
							expect( function(){
								new cfSnowflakeID.snowflake( nodeId=-1 );
							} ).toThrow( message="NodeId must be between 0 and 1023" );
						} );
						then( "It should throw an error for a value exceeding the range", () => {
							expect( function(){
								new cfSnowflakeID.snowflake( nodeId=1024 );
							} ).toThrow( message="NodeId must be between 0 and 1023" );
						} );
					} );
				} );
			} );
			feature( "snowflake generation", () => {
				given( "I am created a new snowflake instance", () => {
					when( "Using the defaults", () => {
						then( "nextid should return a snowflake value", () => {
							var model = new cfSnowflakeID.snowflake();
							var actual = model.nextId();
							expect( actual ).toBeNumeric();
							expect( actual ).toHaveLength( 19 );
						} );
					} );
				} );
			} );
			feature( "snowflake parsing", () => {
				given( "I want to parse the snowflake id", () => {
					when( "I have new snowflake id created using the defaults", () => {
						then( "parse should deconstruct the snowflake id", () => {
							var model = new cfSnowflakeID.snowflake();
							var actual = model.parse( 1268487251117998080 );
							expect( actual ).toHaveLength( 3 );
							expect( actual[ 1 ] ).toBe( 1722501328020, "timestamp" );
							expect( actual[ 2 ] ).toBe( 0, "nodeId" );
							expect( actual[ 3 ] ).toBe( 0, "sequence" );
						} );
					} );
					when( "I have new snowflake id created using a nodeId", () => {
						then( "parse should deconstruct the snowflake id", () => {
							var model = new cfSnowflakeID.snowflake(nodeid=10);
							var actual = model.parse( 1268488299673067520 );
							expect( actual ).toHaveLength( 3 );
							expect( actual[ 1 ] ).toBe( 1722501578015, "timestamp" );
							expect( actual[ 2 ] ).toBe( 10, "nodeId" );
							expect( actual[ 3 ] ).toBe( 0, "sequence" );
						} );
					} );
				} );
			} );
		} );
	}

}

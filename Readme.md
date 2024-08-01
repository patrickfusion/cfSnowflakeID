
# CF SnowflakeID

A SnowflakeID is a unique, distributed identifier generated by the Twitter Snowflake algorithm, primarily used for ensuring unique IDs across a distributed system with high performance. It is best used for generating globally unique IDs in distributed databases, microservices architectures, and other systems where unique and scalable identification is essential.

This a ColdFusion based SnowflakeID generator, this was only built/tested with Lucee.


## How to use

```
snowflake = new snowflake().init(nodeId=1000);

mySnowflakeId = snowflake.nextId();

writedump(mySnowflakeId);
```
## Authors

- [@patrickfusion](https://www.github.com/patrickfusion)



## License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.txt)



## Feedback

If you have any feedback, reach out on CFML Slack:

Patrick Flynn [![Slack](https://img.shields.io/badge/Slack-Profile-blue)](https://cfml.slack.com/team/UAF60SDGE)


## Contributing

Contributions are always welcome!

## Appendix

Here you can learn more about Snowflake ID:

https://en.wikipedia.org/wiki/Snowflake_ID

Also you can pull the timestamp from a working Snowflake ID here:

https://snowsta.mp/

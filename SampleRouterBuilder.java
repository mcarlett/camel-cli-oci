import org.apache.camel.builder.RouteBuilder;
 
public class SampleRouterBuilder extends RouteBuilder {
    public void configure() throws Exception {
        from( "timer://sample")
	  	.log("route is running");
     }
}

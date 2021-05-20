import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("books")
public class Cars {


    @Path("/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String saySomething()
    {
        return "F U Mbvv nn";
    }
}

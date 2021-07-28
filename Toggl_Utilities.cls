/**
 * Created by chrisgibson on 1/8/21.
 */

public with sharing class Toggl_Utilities {

    public abstract class A_TogglWrapper{
        public abstract String getId();
    }



    public class ResponseJSONWrapper {
        public ResponseJSONWrapperDATA data;
    }
    public class ResponseJSONWrapperDATA extends A_TogglWrapper {
        public String name;
        public String id;
        public String wid;
        public Boolean active;
        public Datetime at;
        public Double estimated_seconds;
        public String uname;
        public Double done_seconds;
        public override String getId(){
            return id;
        }
    }

    public static ResponseJSONWrapper parseRequestJSONWrapper(String json){
        return (ResponseJSONWrapper) System.JSON.deserialize(json, ResponseJSONWrapper.class);
    }

    public class TaskJSONWrapper extends A_TogglWrapper {
        public Boolean active;
        public String name;
        public String pid;
        public String uid;
        public String id;
        public Integer estimated_seconds;	//3600
        public String fields;	//done_seconds,uname
        public override String getId(){
            return id;
        }
    }

    public static TaskJSONWrapper parseTaskJSONWrapper(String json){
        return (TaskJSONWrapper) System.JSON.deserialize(json, TaskJSONWrapper.class);
    }

    public class ProjectJSONWrapper {
        public Boolean active;
        public Integer estimated_seconds;	//3600
        public String fields;	//done_seconds,uname
    }

    public static ProjectJSONWrapper parseProjectJSONWRapper(String json){
        return (ProjectJSONWrapper) System.JSON.deserialize(json, ProjectJSONWrapper.class);
    }

    public class TimeEntryResponseWrapper{
        String data;
    }


    public class TimeJSONWrapper extends A_TogglWrapper {
        public String id;
        public String wid;
        public String workspace;
        public String pid;
        public String project;
        public String guid;
        public String uid;
        public String tid;
        public String task;
        public Datetime updated;
        public Boolean is_billable;
        public Double billable;
        public String user;
        public Boolean use_stop;
        public String client;
        public Datetime start;
        public Datetime end_x;
        public Datetime stop;
        public Integer duration;
        public String description;
        public List<String> tags;
        public String at;
        public Boolean duronly;
        public String cur;

        /// for bulk update tag entries
        public String tag_action;

        public override String getId(){
            return id;
        }
    }


    public static TimeJSONWrapper parseTimeJSONWRapper(String json){
        return (TimeJSONWrapper) System.JSON.deserialize(json, TimeJSONWrapper.class);
    }

    public class DetailReportJSONWrapper{
        public String total_grand;
        public String total_billable;
//        public String total_currencies;
        public String total_count;
        public String per_page;
        public List<TimeJSONWrapper> data;
    }

    public static Set<String> GetAllTaskIds(List<TimeJSONWrapper> timeWrappers){

        Set<String> returnSet = new Set<String>();
        for(TimeJSONWrapper curWrap : timeWrappers){

            if(String.isEmpty(curWrap.tid)){
                continue;
            }

            returnSet.add(curWrap.tid);
        }

        return returnSet;
    }

    public static Set<String> GetAllTimeIds(List<TimeJSONWrapper> timeWrappers){

        Set<String> returnSet = new Set<String>();
        for(TimeJSONWrapper curWrap : timeWrappers){

            if(String.isEmpty(curWrap.id)){
                continue;
            }

            returnSet.add(curWrap.id);
        }

        return returnSet;
    }


    public static Boolean CheckIfTagExists(Toggl_Utilities.TimeJSONWrapper curTimeWrap, String tagToCheck) {
        for (String curTag : curTimeWrap.tags) {
            if (curTag == tagToCheck) {
                return true;
            }
        }

        return false;
    }


}

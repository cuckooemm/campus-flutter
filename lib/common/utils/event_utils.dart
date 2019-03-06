import 'package:event_bus/event_bus.dart';

class EventUtils {
  static EventBus eventBus = new EventBus();
//  ///事件描述与动作
//  static getActionAndDes(Event event) {
//    String actionStr;
//    String des;
//    switch (event.type) {
//      case "CommitCommentEvent":
//        actionStr = "Commit comment at " + event.repo.name;
//        break;
//      case "CreateEvent":
//        if (event.payload.refType == "repository") {
//          actionStr = "Created repository " + event.repo.name;
//        } else {
//          actionStr = "Created " + event.payload.refType + " " + event.payload.ref + " at " + event.repo.name;
//        }
//        break;
//      case "DeleteEvent":
//        actionStr = "Delete " + event.payload.refType + " " + event.payload.ref + " at " + event.repo.name;
//        break;
//      case "ForkEvent":
//        String oriRepo = event.repo.name;
//        String newRepo = event.actor.login + "/" + event.repo.name;
//        actionStr = "Forked " + oriRepo + " to " + newRepo;
//        break;
//      case "GollumEvent":
//        actionStr = event.actor.login + " a wiki page ";
//        break;
//
//      case "InstallationEvent":
//        actionStr = event.payload.action + " an GitHub App ";
//        break;
//      case "InstallationRepositoriesEvent":
//        actionStr = event.payload.action + " repository from an installation ";
//        break;
//      case "IssueCommentEvent":
//        actionStr = event.payload.action + " comment on issue " + event.payload.issue.number.toString() + " in " + event.repo.name;
//        des = event.payload.comment.body;
//        break;
//      case "IssuesEvent":
//        actionStr = event.payload.action + " issue " + event.payload.issue.number.toString() + " in " + event.repo.name;
//        des = event.payload.issue.title;
//        break;
//
//      case "MarketplacePurchaseEvent":
//        actionStr = event.payload.action + " marketplace plan ";
//        break;
//      case "MemberEvent":
//        actionStr = event.payload.action + " member to " + event.repo.name;
//        break;
//      case "OrgBlockEvent":
//        actionStr = event.payload.action + " a user ";
//        break;
//      case "ProjectCardEvent":
//        actionStr = event.payload.action + " a project ";
//        break;
//      case "ProjectColumnEvent":
//        actionStr = event.payload.action + " a project ";
//        break;
//
//      case "ProjectEvent":
//        actionStr = event.payload.action + " a project ";
//        break;
//      case "PublicEvent":
//        actionStr = "Made " + event.repo.name + " public";
//        break;
//      case "PullRequestEvent":
//        actionStr = event.payload.action + " pull request " + event.repo.name;
//        break;
//      case "PullRequestReviewEvent":
//        actionStr = event.payload.action + " pull request review at" + event.repo.name;
//        break;
//      case "PullRequestReviewCommentEvent":
//        actionStr = event.payload.action + " pull request review comment at" + event.repo.name;
//        break;
//      case "ReleaseEvent":
//        actionStr = event.payload.action + " release " + event.payload.release.tagName + " at " + event.repo.name;
//        break;
//      case "WatchEvent":
//        actionStr = event.payload.action + " " + event.repo.name;
//        break;
//    }
//
//    return {"actionStr": actionStr, "des": des != null ? des : ""};
//  }
//
//  ///跳转
//  static ActionUtils(BuildContext context, Event event, currentRepository) {
//    if (event.repo == null) {
////      NavigatorUtils.goPerson(context, event.actor.login);
//      return;
//    }
//    String owner = event.repo.name.split("/")[0];
//    String repositoryName = event.repo.name.split("/")[1];
//    String fullName = owner + '/' + repositoryName;
//  }
}
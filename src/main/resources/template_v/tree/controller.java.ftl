package ${package.Controller};

import org.springframework.web.bind.annotation.RequestMapping;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>
import ${package.Entity}.${entity};
import ${path}.dao.model.${model?cap_first};
import ${package.Service}.${table.serviceName};
import java.util.List;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dt.core.model.RequestWrapper;
import com.dt.core.model.PageReplyResponse;
import com.dt.core.model.PageRequest;
import com.dt.core.model.ReplyResponse;

import com.dt.core.tools.MyHttpTools;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import com.dt.context.model.UserVo;
import com.dt.gongan.manager.DatabaseManager;
import com.dt.gongan.dao.converter.${model?cap_first}Converter;
/**
 * <p>
 * ${table.comment!} 前端控制器
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if restControllerStyle>
@Slf4j
@RestController
@Api(tags = "${entity?substring(1,3)} ${table.comment!}", description = "<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#else>
@Controller
</#if>
@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
<#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
<#else>
public class ${table.controllerName} {
</#if>
    @Autowired
    private ${table.serviceName} ${'${table.serviceName}'?uncap_first};

    @Autowired
    private DatabaseManager databaseManager;

    @ApiOperation(value="进行${table.comment!}树形结构", notes="进行${table.comment!}树形结构")
    @PostMapping(value = {"tree"})
    public ReplyResponse tree(@RequestHeader(value = "current-user") String userJson,
            @RequestHeader(value = "sessionToken") String sessionToken) {
        try {
            UserVo loginUserDto = MyHttpTools.convertUserVo(userJson);
            log.info("login user: {}, sessionToken: {}", loginUserDto, sessionToken);

            List<${entity}> result = ${table.serviceName}.findTree();
            return ReplyResponse.ok(result);
        }catch(Exception e){
            log.error("查询${table.comment!}树形数据异常：",e);
            return ReplyResponse.error(e.getMessage());
        }
    }

    @ApiOperation(value = "${table.comment!}分页查询", notes = "page")
    @PostMapping("/page")
    public PageReplyResponse<List<${entity}>> page(
            @RequestBody PageRequest<${entity}> pageRequest,
            @RequestHeader(value = "current-user") String userJson,
            @RequestHeader(value = "sessionToken") String sessionToken,
            HttpServletRequest request) {
        MyHttpTools.printHeaderInfo(request);
        //用户信息处理
        UserVo loginUserDto = MyHttpTools.convertUserVo(userJson);
        log.info("requestWrapper: {}, login user: {}, sessionToken: {}", pageRequest, loginUserDto, sessionToken);

        //接口获取完整的当前用户信息
        UserVo user = databaseManager.queryUserDetail(loginUserDto.getId());
        log.info("user: {}", user);

        log.info("page request: {}", pageRequest);

        IPage<${entity}> page = new Page<>(pageRequest.getCurrentPage(),
                pageRequest.getPageSize(), true);
        ${entity} ${'${entity}'?uncap_first} = pageRequest.getData();
        IPage resultPage = ${'${table.serviceName}'?uncap_first}.selectPage(page, ${'${entity}'?uncap_first});
        List<${model?cap_first}> resultModels=${model?cap_first}Converter.converterToVO(resultPage.getRecords());
        resultPage.setRecords(resultModels);
        return PageReplyResponse.page(resultPage);
    }

    @ApiOperation(value = "${table.comment!}列表查询", notes = "list")
    @PostMapping("/list")
    public ReplyResponse<List<${entity}>> list(
            @RequestBody RequestWrapper<${entity}> requestWrapper,
            @RequestHeader(value = "current-user") String userJson,
            @RequestHeader(value = "sessionToken") String sessionToken,
            HttpServletRequest request) {
        MyHttpTools.printHeaderInfo(request);
        //用户信息处理
        UserVo loginUserDto = MyHttpTools.convertUserVo(userJson);
        log.info("requestWrapper: {}, login user: {}, sessionToken: {}", requestWrapper, loginUserDto, sessionToken);

        //接口获取完整的当前用户信息
        UserVo user = databaseManager.queryUserDetail(loginUserDto.getId());
        log.info("user: {}", user);

        log.info("list request: {}", requestWrapper);

        ${entity} ${'${entity}'?uncap_first} = requestWrapper.getData();
        List<${entity}> resultList =
            ${'${table.serviceName}'?uncap_first}.selectList(${'${entity}'?uncap_first});

        return ReplyResponse.ok(resultList);
    }

    @ApiOperation(value = "明细记录", notes = "detail")
    @PostMapping("/detail")
    public ReplyResponse<${entity}> detail(
            @RequestBody RequestWrapper<Long> requestWrapper,
            @RequestHeader(value = "current-user") String userJson,
            @RequestHeader(value = "sessionToken") String sessionToken,
            HttpServletRequest request) {
        MyHttpTools.printHeaderInfo(request);
        //用户信息处理
        UserVo loginUserDto = MyHttpTools.convertUserVo(userJson);
        log.info("requestWrapper: {}, login user: {}, sessionToken: {}", requestWrapper, loginUserDto, sessionToken);

        //接口获取完整的当前用户信息
        UserVo user = databaseManager.queryUserDetail(loginUserDto.getId());
        log.info("user: {}", user);

        log.info("detail request: {}", requestWrapper);
        ${entity} result = ${'${table.serviceName}'?uncap_first}.getById(requestWrapper.getData());

        ${model?cap_first} resultModel=${model?cap_first}Converter.converterToVO(result);
        return ReplyResponse.ok(resultModel);
    }

}
</#if>

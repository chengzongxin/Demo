//
//  TMCardComponentMacro.h
//  THKCardComponentsTest
//
//  Created by nigel.ning on 2020/4/7.
//  Copyright © 2020 t8t. All rights reserved.
//

#ifndef TMCardComponentMacro_h
#define TMCardComponentMacro_h

#ifdef TMUI_PropertySyntheSize
    #define TMCardComponentProtocolSyntheSize(propertyName)     TMUI_PropertySyntheSize(propertyName)
#else
    #define TMCardComponentProtocolSyntheSize(propertyName) \
    @synthesize propertyName = _##propertyName;

#endif

///NSObject类型的属性的懒加载宏

#ifdef TMUI_PropertyLazyLoad
    #define TMCardComponentPropertyLazyLoad(Type, propertyName)     TMUI_PropertyLazyLoad(Type, propertyName)
#else
    #define TMCardComponentPropertyLazyLoad(Type, propertyName) \
    - (Type *)propertyName { \
        if (!_##propertyName) {\
            _##propertyName = [[Type alloc] init]; \
        } \
        return _##propertyName; \
    }   \

#endif

#endif /* TMCardComponentMacro_h */

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JsionFramework.Jsion.Attributes
{
    [AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
    public class AppConfigAttribute : Attribute
    {
        private string m_key;
        private string m_description;
        private object m_defaultValue;

        public AppConfigAttribute(string key, string description, object defaultValue)
        {
            m_key = key;
            m_description = description;
            m_defaultValue = defaultValue;
        }

        public string Key
        {
            get
            {
                return m_key;
            }
        }

        public string Description
        {
            get
            {
                return m_description;
            }
        }

        public object DefaultValue
        {
            get
            {
                return m_defaultValue;
            }
        }
    }
}

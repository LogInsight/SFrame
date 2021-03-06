/**
 * Copyright (C) 2015 Dato, Inc.
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license. See the LICENSE file for details.
 */
#ifndef GRAPHLAB_SFRAME_QUERY_MANAGER_CONSTANT_HPP
#define GRAPHLAB_SFRAME_QUERY_MANAGER_CONSTANT_HPP
#include <logger/assertions.hpp>
#include <flexible_type/flexible_type.hpp>
#include <sframe_query_engine/operators/operator.hpp>
#include <sframe_query_engine/execution/query_context.hpp>
#include <sframe_query_engine/operators/operator_properties.hpp>
namespace graphlab { 
namespace query_eval {

/**
 * A "constant" operator which simply generates "len" instances of a particular
 * value.
 *
 * This operator exists largely for demonstration purposes. It is not really
 * safe to use in an actual query execution context since 
 * spliting and parallelizing this operator actually requires additional work
 * computing the lengths of each parallel stream. 
 *
 * To correctly handle the constant operator requires the query evaluator
 * to support "infinite length streams" (which is probably another operator
 * attribute). 
 */
template <>
struct operator_impl<planner_node_type::CONSTANT_NODE> : public query_operator {
 public:

  planner_node_type type() const { return planner_node_type::CONSTANT_NODE; }

  static std::string name() { return "constant"; }
  
  static query_operator_attributes attributes() {
    query_operator_attributes ret;
    ret.attribute_bitfield = query_operator_attributes::SOURCE;
    ret.num_inputs = 0;
    return ret;
  }

  inline operator_impl(flexible_type value, size_t len)
  : m_value(value)
  , m_len(len)
  { }
  
  inline std::string print() const {
    return std::string("constant(") + (std::string)m_value + ")";
  }

  inline std::shared_ptr<query_operator> clone() const {
    return std::make_shared<operator_impl>(m_value, m_len);
  }

  inline void execute(query_context& context) {
    size_t i = 0;
    while(i < m_len) {
      auto ret = context.get_output_buffer();
      size_t len = std::min(m_len - i, context.block_size());

      ret->resize(1, len);
      for (auto& value: *(ret->get_columns()[0])) value = m_value;
      context.emit(ret);
      i += len;
    }
  }

  static std::shared_ptr<planner_node> make_planner_node(const flexible_type& val,
                                            flex_type_enum type,
                                            size_t count) {
    ASSERT_TRUE(val.get_type() == type || val.get_type() == flex_type_enum::UNDEFINED);
    return planner_node::make_shared(planner_node_type::CONSTANT_NODE, 
                                     {{"value", val}, 
                                       {"type", (int)type},
                                       {"begin_index", 0},
                                       {"end_index", count}});
  }

  static std::shared_ptr<query_operator> from_planner_node(
      std::shared_ptr<planner_node> pnode) {
    
    ASSERT_EQ((int)pnode->operator_type, (int)planner_node_type::CONSTANT_NODE);
    ASSERT_TRUE(pnode->operator_parameters.count("value"));
    ASSERT_TRUE(pnode->operator_parameters.count("begin_index"));
    ASSERT_TRUE(pnode->operator_parameters.count("end_index"));
    ASSERT_TRUE(pnode->operator_parameters.count("type"));
    size_t count = (flex_int)pnode->operator_parameters["end_index"] -
                   (flex_int)pnode->operator_parameters["begin_index"];
    return std::make_shared<operator_impl>(pnode->operator_parameters["value"], count);
  }

  static std::vector<flex_type_enum> infer_type(
      std::shared_ptr<planner_node> pnode) {
    ASSERT_EQ((int)pnode->operator_type, (int)planner_node_type::CONSTANT_NODE);
    ASSERT_TRUE(pnode->operator_parameters.count("type"));
    return {(flex_type_enum)(int)(pnode->operator_parameters["type"])};
  }

  static int64_t infer_length(std::shared_ptr<planner_node> pnode) {
    ASSERT_EQ((int)pnode->operator_type, (int)planner_node_type::CONSTANT_NODE);
    size_t count = (flex_int)pnode->operator_parameters["end_index"] -
                   (flex_int)pnode->operator_parameters["begin_index"];
    return count;
  }
  
  static std::string repr(std::shared_ptr<planner_node> pnode, pnode_tagger&) {
    ASSERT_EQ((int)pnode->operator_type, (int)planner_node_type::CONSTANT_NODE);
    ASSERT_TRUE(pnode->operator_parameters.count("value"));
    ASSERT_TRUE(pnode->operator_parameters.count("begin_index"));
    ASSERT_TRUE(pnode->operator_parameters.count("end_index"));

    flexible_type v = pnode->operator_parameters["value"];
    flex_int begin_index = pnode->operator_parameters["begin_index"];
    flex_int end_index = pnode->operator_parameters["end_index"];

    std::ostringstream ss;

    ss << "Const(" << v << ")[" << begin_index << ":" << end_index << "]";

    return ss.str();
  }

 private:
  flexible_type m_value;
  size_t m_len = 0;
};

typedef operator_impl<planner_node_type::CONSTANT_NODE> op_constant;

} // query_eval
} // graphlab

#endif // GRAPHLAB_SFRAME_QUERY_MANAGER_CONSTANT_HPP

/*
 * Copyright © 2017-2019 Cask Data, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package io.cdap.wrangler.api.parser;

import com.google.gson.JsonElement;
import io.cdap.wrangler.api.annotations.PublicEvolving;

import java.io.Serializable;

/**
 * The Token class represents the object that contains the value and type of
 * the token as parsed by the parser of the grammar defined for recipe.
 *
 * <p>This class provides methods for retrieving the wrapped value of token parsed
 * as well the type of token the implementation of this interface represents.</p>
 *
 * <p>It also provides method for providing the {@code JsonElement} of implementation
 * of this interface.</p>
 */
@PublicEvolving
public interface Token extends Serializable {
  /**
   * Returns the {@code value} of the object wrapped by the
   * implementation of this interface.
   *
   * @return {@code value} wrapped by the implementation of this interface.
   */
  Object value();

  /**
   * Returns the {@code TokenType} of the object represented by the
   * implementation of this interface.
   *
   * @return {@code TokenType} of the implementation object.
   */
  TokenType type();

  /**
   * The class implementing this interface will return the {@code JsonElement}
   * instance including the values of the object.
   *
   * @return {@code JsonElement} object containing members of  implementing class.
   */
  JsonElement toJson();
}
package io.cdap.wrangler.api.parser;

public enum TokenType {
  STRING,
  NUMBER,
  BOOLEAN,
  COLUMN_NAME,
  BYTE_SIZE,
  TIME_DURATION
}
package io.cdap.wrangler.api.parser;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import io.cdap.wrangler.api.Token;

public class ByteSize implements Token {
  private final long bytes;
  private final String raw;

  public ByteSize(String value) {
    this.raw = value;
    this.bytes = parseByteSize(value);
  }

  public long getBytes() {
    return bytes;
  }

  @Override
  public String value() {
    return raw;
  }

  @Override
  public TokenType type() {
    return TokenType.BYTE_SIZE;
  }

  @Override
  public JsonElement toJson() {
    JsonObject json = new JsonObject();
    json.addProperty("value", raw);
    json.addProperty("bytes", bytes);
    return json;
  }

  private long parseByteSize(String value) {
    String normalized = value.toLowerCase();
    double num = Double.parseDouble(normalized.replaceAll("[^0-9.]", ""));
    String unit = normalized.replaceAll("[0-9.]", "");

    switch (unit) {
      case "b": return (long) num;
      case "kb": return (long) (num * 1000);
      case "kib": return (long) (num * 1024);
      case "mb": return (long) (num * 1000 * 1000);
      case "mib": return (long) (num * 1024 * 1024);
      case "gb": return (long) (num * 1000 * 1000 * 1000);
      case "gib": return (long) (num * 1024 * 1024 * 1024);
      case "tb": return (long) (num * 1000 * 1000 * 1000 * 1000);
      case "tib": return (long) (num * 1024 * 1024 * 1024 * 1024);
      default: throw new IllegalArgumentException("Unknown byte unit: " + unit);
    }
  }
}
package io.cdap.wrangler.api.parser;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import io.cdap.wrangler.api.Token;

public class TimeDuration implements Token {
  private final long nanos;
  private final String raw;

  public TimeDuration(String value) {
    this.raw = value;
    this.nanos = parseTimeDuration(value);
  }

  public long getNanos() {
    return nanos;
  }

  @Override
  public String value() {
    return raw;
  }

  @Override
  public TokenType type() {
    return TokenType.TIME_DURATION;
  }

  @Override
  public JsonElement toJson() {
    JsonObject json = new JsonObject();
    json.addProperty("value", raw);
    json.addProperty("nanos", nanos);
    return json;
  }

  private long parseTimeDuration(String value) {
    String normalized = value.toLowerCase();
    double num = Double.parseDouble(normalized.replaceAll("[^0-9.]", ""));
    String unit = normalized.replaceAll("[0-9.]", "");

    switch (unit) {
      case "ns": return (long) num;
      case "us": return (long) (num * 1000);
      case "ms": return (long) (num * 1000 * 1000);
      case "s": return (long) (num * 1000 * 1000 * 1000);
      case "m": return (long) (num * 60 * 1000 * 1000 * 1000);
      case "h": return (long) (num * 3600 * 1000 * 1000 * 1000);
      case "d": return (long) (num * 24 * 3600 * 1000 * 1000 * 1000);
      default: throw new IllegalArgumentException("Unknown time unit: " + unit);
    }
  }
}



